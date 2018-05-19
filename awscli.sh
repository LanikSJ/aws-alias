#!/usr/bin/env bash
# This script will install/Update AWS CLI

# Install / Update Function
awscli() {
  case `uname` in
    "Darwin" )
      type brew
      if [ $? != 0 ]
      then
        echo "brew not found. Please install at http://brew.sh"
        exit 1
      else
        echo "brew already installed..."
      fi

      type python3
      if [ $? != 0 ]
      then
        echo "python3 not found. Installing.."
        brew install python3
        if [ $? != 0 ]
        then
          echo "Failed to install python3.."
          exit 1
        fi
      else
        echo "python3 already installed..."
      fi

      type pip3
      if [ $? != 0 ]
      then
        echo "pip3 not found. Please correct."
        exit 1
      else
        echo "pip3 already installed..."
      fi

      pip3 show awscli
      if [ $? != 0 ]
      then
        echo "AWS CLI not installed using pip. "
        pip3 install awscli
      else
        echo "AWS CLI already installed using pip, upgrading..."
        pip3 install -U awscli
      fi
      ;;
    Linux )
      echo "For Linux systems, please manually install / update AWS CLI. "
      exit 1
      ;;
    * )
      echo "`uname` is an unsupported OS. Please manually install / update AWS CLI. "
      exit 1
      ;;
  esac
}

# Variables
AWSVERSION=$(aws --version | awk -F"/" '{print $2}' |sed 's/ Python//')
AWSCURRENT=$(curl -sSL https://api.github.com/repos/aws/aws-cli/tags | jq '.[0]' | jq '.["name"]' |sed 's/"//g')

if [[ -z $AWSVERSION ]]; then
  echo "AWS CLI isn't installed. Installing ... "
  awscli && rm -f /tmp/version.txt
else
  echo "Your AWS CLI version is: $AWSVERSION"
fi

if [[ $AWSVERSION < "$AWSCURRENT" ]]; then
  echo "Your version of AWS CLI is out of date! Updating ... "
  awscli && rm -f /tmp/version.txt
else
  echo "Your version of AWS CLI is up to date! Nothing to do. "
  rm -f /tmp/version.txt
fi