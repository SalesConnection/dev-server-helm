{{/*
Expand the name of the chart.
*/}}
{{- define "devserver.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "devserver.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "devserver.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "devserver.labels" -}}
helm.sh/chart: {{ include "devserver.chart" . }}
{{ include "devserver.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "devserver.selectorLabels" -}}
app.kubernetes.io/name: {{ include "devserver.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "devserver.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "devserver.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the PVC name for a user.
For EFS dynamic provisioning, the PVC name is intentionally the user name so
subPathPattern can create stable directories such as /dev/wang.
*/}}
{{- define "devserver.pvcName" -}}
{{- $root := .root -}}
{{- $user := .user -}}
{{- if eq $root.Values.persistence.type "efs" -}}
{{- $user.name -}}
{{- else -}}
{{- printf "%s-ebs" $user.name -}}
{{- end -}}
{{- end }}

{{/*
Resolve the StorageClass used by user PVCs.
*/}}
{{- define "devserver.storageClassName" -}}
{{- if eq .Values.persistence.type "efs" -}}
{{- .Values.persistence.efs.storageClassName -}}
{{- else -}}
{{- .Values.persistence.ebs.storageClassName | default "gp2" -}}
{{- end -}}
{{- end }}

{{/*
Resolve the PVC storage request. EFS is elastic; Kubernetes still requires a
request value, but EFS does not enforce that capacity.
*/}}
{{- define "devserver.storageRequest" -}}
{{- $root := .root -}}
{{- $user := .user -}}
{{- if eq $root.Values.persistence.type "efs" -}}
{{- $root.Values.persistence.efs.storageRequest | default "5Gi" -}}
{{- else -}}
{{- $user.storage | default $root.Values.persistence.ebs.storageRequest | default "30Gi" -}}
{{- end -}}
{{- end }}
