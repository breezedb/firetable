#!/bin/bash

helpFunction()
{
   echo "Usage: ./deploy.sh --firebase-token [YOUR FIREBASE TOKEN] --project-id [YOUR GCLOUD PROJECT ID]"
   exit 0
}

while test $# -gt 0; do
           case "$1" in
                --firebase-token)
                    shift
                    firebase_token=$1
                    shift
                    ;;
                --project-id)
                    shift
                    project_id=$1
                    shift
                    ;;
                *)
                   echo "$1 is not a recognized flag!"
                   return 1;
                   ;;
          esac
  done  

if [[ -z "$firebase_token" || -z "$project_id" ]];
then
   helpFunction
fi

gcloud builds submit --tag gcr.io/$project_id/ft-builder
gcloud run deploy ft-builder --image gcr.io/$project_id/ft-builder --platform managed --memory 4Gi --allow-unauthenticated --set-env-vars="_FIREBASE_TOKEN=$firebase_token,_PROJECT_ID=$project_id"