#!/usr/bin/env bash
# Shared ownership checks for regular definitions and legacy repository links.

load_catalogue_identity() {
  CATALOGUE_ID="$(cat "$REPOSITORY_DIRECTORY/catalogue-id")" || return 1
  [[ "$CATALOGUE_ID" =~ ^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$ ]] || {
    echo "Invalid catalogue identity: $REPOSITORY_DIRECTORY/catalogue-id" >&2
    return 1
  }
}

profile_key_for() {
  printf '%s' "${1#"$REPOSITORY_DIRECTORY"/}"
}

definition_payload() {
  sed '/^# personal-agents-catalogue: /d; /^# personal-agents-source: /d; /^# personal-agents-checksum: /d' "$1"
}

is_owned_link() {
  [[ -L "$1" && "$(readlink "$1")" == "$2" ]]
}

is_owned_copy() {
  local destination="$1" agent_file="$2" catalogue_id source_key recorded_checksum
  [[ -f "$destination" && ! -L "$destination" ]] || return 1
  catalogue_id="$(sed -n 's/^# personal-agents-catalogue: //p' "$destination")"
  [[ "$catalogue_id" == "$CATALOGUE_ID" ]] || return 1
  source_key="$(sed -n 's/^# personal-agents-source: //p' "$destination")"
  [[ "$source_key" == "$(profile_key_for "$agent_file")" ]] || return 1
  recorded_checksum="$(sed -n 's/^# personal-agents-checksum: //p' "$destination")"
  [[ "$recorded_checksum" =~ ^[0-9]+[[:space:]][0-9]+$ ]] || return 1
  [[ "$(definition_payload "$destination" | cksum)" == "$recorded_checksum" ]]
}

is_current_copy() {
  is_owned_copy "$1" "$2" && cmp -s "$2" <(definition_payload "$1")
}

write_definition() {
  local agent_file="$1" destination="$2" temporary_file source_key checksum
  source_key="$(profile_key_for "$agent_file")"
  checksum="$(cksum < "$agent_file")"
  temporary_file="$(mktemp "$TARGET_DIRECTORY/.personal-agents.XXXXXX")"
  if ! {
    if [[ "$RUNTIME" == "claude" ]]; then
      head -n 1 "$agent_file"
    fi
    printf '# personal-agents-catalogue: %s\n# personal-agents-source: %s\n# personal-agents-checksum: %s\n' "$CATALOGUE_ID" "$source_key" "$checksum"
    if [[ "$RUNTIME" == "claude" ]]; then
      tail -n +2 "$agent_file"
    else
      cat "$agent_file"
    fi
  } > "$temporary_file"; then
    rm -f -- "$temporary_file"
    return 1
  fi
  if ! mv -f -- "$temporary_file" "$destination"; then
    rm -f -- "$temporary_file"
    return 1
  fi
}
