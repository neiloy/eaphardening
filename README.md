# eaphardening
Git repository necessary for hardening EAP 6.4 in OpenShift


Make sure to change dockerbuild/Dockerfile to use the correct baseline EAP 6.4 image.

Once the above is complete, go ahead and run oc new-build and include --config-dir='./dockerbuild' in the arguments. Including a -D or --dockerfile argument will supercede the Dockerfile in the dockerbuild directory.

