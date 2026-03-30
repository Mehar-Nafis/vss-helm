{{/*
Expand the name of the chart.
*/}}
{{- define "vss.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Full name: release-name (truncated to 63 chars).
*/}}
{{- define "vss.fullname" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Chart label: name-version
*/}}
{{- define "vss.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels applied to every resource.
*/}}
{{- define "vss.labels" -}}
helm.sh/chart: {{ include "vss.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{/*
Selector labels for a given component.
Usage: {{ include "vss.selectorLabels" (dict "root" . "component" "via-server") }}
*/}}
{{- define "vss.selectorLabels" -}}
app.kubernetes.io/name: {{ include "vss.name" .root }}
app.kubernetes.io/instance: {{ .root.Release.Name }}
app.kubernetes.io/component: {{ .component }}
{{- end }}

{{/*
Service Account name.
*/}}
{{- define "vss.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (printf "%s-sa" (include "vss.fullname" .)) .Values.serviceAccount.name }}
{{- else -}}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
PVC storage class helper – returns storageClass if set, else cluster default.
Usage: {{ include "vss.storageClass" (dict "global" .Values.persistence.storageClass "local" .Values.persistence.redisData.storageClass) }}
*/}}
{{- define "vss.storageClass" -}}
{{- $sc := .local | default .global -}}
{{- if $sc -}}
storageClassName: {{ $sc | quote }}
{{- end }}
{{- end }}

{{/*
Internal service DNS name for a component.
Usage: {{ include "vss.svcName" (dict "root" . "component" "redis") }}
*/}}
{{- define "vss.svcName" -}}
{{- printf "%s-%s" .root.Release.Name .component }}
{{- end }}

{{/*
OpenShift Route host helper.
Usage: {{ include "vss.routeHost" (dict "root" . "prefix" "api-gateway") }}
*/}}
{{- define "vss.routeHost" -}}
{{- if .root.Values.route.baseDomain -}}
{{- printf "%s-%s.%s" .root.Release.Name .prefix .root.Values.route.baseDomain }}
{{- end }}
{{- end }}
