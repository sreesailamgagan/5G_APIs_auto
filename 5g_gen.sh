#!/bin/bash
generator=$1
genfile=$2

if [ "$generator" == "all" ]; then
	while read p; do
		rm -rf $p
		for specs in $(ls ./5G_APIs/*.yaml); do
			package_name=$(basename "${specs%.*}" | cut -d'_' -f2- | tr '-' '_')
			package_name="openapi_$package_name" # Adding the prefix openapi_ to avoid conflicts with numbers in the name (e.g. 5GC_APIs/1.yaml)
			echo "Generating $package_name"
			java -Xmx1024M -jar openapi-generator-cli.jar generate -i "$specs" -g $p -o ./$p/"$package_name" --skip-validate-spec --additional-properties=isGoSubmodule=true,packageName="$package_name",useOneOfDiscriminatorLookup=false,apiTests=false,modelTests=false --openapi-normalizer REF_AS_PARENT_IN_ALLOF=true
			echo "Done"
		done
	done <demo_file.txt
else
	rm -rf $generator
	if [ "$genfile" == "all" ]; then
		for specs in $(ls ./5G_APIs/*.yaml); do
			package_name=$(basename "${specs%.*}" | cut -d'_' -f2- | tr '-' '_')
			package_name="openapi_$package_name" # Adding the prefix openapi_ to avoid conflicts with numbers in the name (e.g. 5GC_APIs/1.yaml)
			echo "Generating $package_name"
			java -Xmx1024M -jar openapi-generator-cli.jar generate -i "$specs" -g $generator -o ./$generator/"$package_name" --skip-validate-spec --additional-properties=isGoSubmodule=true,packageName="$package_name",useOneOfDiscriminatorLookup=false,apiTests=false,modelTests=false --openapi-normalizer REF_AS_PARENT_IN_ALLOF=true
			echo "Done"
		done
	else
		package_name=$(basename "${genfile%.*}" | cut -d'_' -f2- | tr '-' '_')
		package_name="openapi_$package_name" # Adding the prefix openapi_ to avoid conflicts with numbers in the name (e.g. 5GC_APIs/1.yaml)
		echo "Generating $package_name"
		java -Xmx1024M -jar openapi-generator-cli.jar generate -i ./5G_APIs/"$genfile" -g $generator -o ./$generator/"$package_name" --skip-validate-spec --additional-properties=isGoSubmodule=true,packageName="$package_name",useOneOfDiscriminatorLookup=false,apiTests=false,modelTests=false --openapi-normalizer REF_AS_PARENT_IN_ALLOF=true
		echo "Done"
	fi
fi

