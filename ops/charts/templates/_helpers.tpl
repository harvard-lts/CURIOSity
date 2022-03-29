{{/*
Expand the name of the chart.
*/}}
{{- define "spotlight.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "spotlight.fullname" -}}
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
{{- define "spotlight.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "spotlight.labels" -}}
helm.sh/chart: {{ include "spotlight.chart" . }}
{{ include "spotlight.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "spotlight.selectorLabels" -}}
app.kubernetes.io/name: {{ include "spotlight.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "spotlight.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "spotlight.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Set values for postgresql connection
*/}}
{{- define "spotlight.postgresql.fullname" -}}
{{- printf "%s-%s" .Release.Name "postgresql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "spotlight.postgresql.host" -}}
{{- if .Values.postgresql.enabled }}
{{- include "spotlight.postgresql.fullname" . }}
{{- else }}
{{- .Values.externalPostgresql.host }}
{{- end }}
{{- end -}}

{{- define "spotlight.postgresql.database" -}}
{{- if .Values.postgresql.enabled }}
{{- .Values.postgresql.postgresqlDatabase }}
{{- else }}
{{- .Values.externalPostgresql.database | default ( include "spotlight.fullname" . ) }}
{{- end }}
{{- end -}}

{{- define "spotlight.postgresql.username" -}}
{{- if .Values.postgresql.enabled }}
{{- .Values.postgresql.postgresqlUsername }}
{{- else }}
{{- .Values.externalPostgresql.username | default "postgres" }}
{{- end }}
{{- end -}}

{{- define "spotlight.postgresql.password" -}}
{{- if .Values.postgresql.enabled }}
{{- .Values.postgresql.postgresqlPassword }}
{{- else }}
{{- .Values.externalPostgresql.password }}
{{- end }}
{{- end -}}

{{/*
Set values for redis connection
*/}}

{{- define "spotlight.redis.fullname" -}}
{{- printf "%s-%s" .Release.Name "redis" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "spotlight.redis.host" -}}
{{- printf "%s-master" (include "spotlight.redis.fullname" .) -}}
{{- end -}}

{{- define "spotlight.redis.url" -}}
{{- printf "redis://:%s@%s:%s" .Values.redis.password (include "spotlight.redis.host" .) "6379/0" -}}
{{- end -}}


{{/*
Set values for solr connection
*/}}

{{- define "spotlight.solr.fullname" -}}
{{- printf "%s-%s" .Release.Name "solr" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "spotlight.solr.host" -}}
{{- if .Values.solr.enabled }}
{{- include "spotlight.solr.fullname" . }}
{{- else }}
{{- .Values.externalSolrHost }}
{{- end }}
{{- end -}}

{{- define "spotlight.solr.collectionName" -}}
{{- if .Values.solr.enabled }}
{{- .Values.solr.collection | default "spotlight" }}
{{- else }}
{{- .Values.externalSolrCollection | default "spotlight" }}
{{- end }}
{{- end -}}

{{- define "spotlight.solr.username" -}}
{{- if .Values.solr.enabled }}
{{- .Values.solr.authentication.adminUsername }}
{{- else }}
{{- .Values.externalSolrUser }}
{{- end }}
{{- end -}}

{{- define "spotlight.solr.password" -}}
{{- if .Values.solr.enabled }}
{{- .Values.solr.authentication.adminPassword }}
{{- else }}
{{- .Values.externalSolrPassword }}
{{- end }}
{{- end -}}

{{- define "spotlight.solr.url" -}}
{{- printf "http://%s:%s@%s:%s/solr/%s" (include "spotlight.solr.username" .) (include "spotlight.solr.password" .) (include "spotlight.solr.host" .) "8983" (include "spotlight.solr.collectionName" .)  -}}
{{- end -}}

{{- define "spotlight.zk.fullname" -}}
{{- printf "%s-%s" .Release.Name "zookeeper" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
