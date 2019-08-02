# For more info, see https://github.com/coq-community/docker-coq/wiki/CI-setup#remarks

ARG coq_image="coqorg/coq:dev"
FROM ${coq_image}

LABEL maintainer="author@example.org"

WORKDIR /home/coq/demo

COPY _CoqProject .

RUN ["/bin/bash", "--login", "-c", "set -x \
  && if [ -n \"${COMPILER_EDGE}\" ]; then opam switch ${COMPILER_EDGE} && eval $(opam env); fi \
  && opam update -y \
  # TODO: specify dependencies below
  && opam install -y -v -j ${NJOBS} coq-mathcomp-ssreflect \
  && opam config list && opam repo list && opam list \
  && opam clean -a -c -s --logs"]

COPY src src

RUN ["/bin/bash", "--login", "-c", "set -x \
  && sudo chown -R coq:coq /home/coq/demo \
  # TODO: update configuration/build step below
  && coq_makefile -f _CoqProject -o Makefile \
  && make -j ${NJOBS} \
  && make install"]
