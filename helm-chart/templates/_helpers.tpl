{{/* _helpers.tpl */}}

{{- define "config-map-contents" -}}
{{- range $key, $val := .Values.configmap }}
{{ $key }}: {{ $val | quote }}
{{- end }}
{{- end -}}

{{- define "secret-contents" -}}
{{- range $key, $val := .Values.secret }}
{{ $key }}: {{ $val | b64enc }}
{{- end }}
{{- end -}}

{{- define "secret-labels" -}}
{{- range $key, $val := (.Values.labels).secret }}
{{ $key }}: {{ $val }}
{{- end }}
{{- end -}}
