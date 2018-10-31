FROM coqorg/coq:dev

RUN ["/bin/bash", "--login", "-c", "set -x \
  && opam update -y \
  && opam install -y -j ${NJOBS} coq-mathcomp-ssreflect"]

WORKDIR /home/coq/demo

COPY _CoqProject .
COPY src src

RUN ["/bin/bash", "--login", "-c", "set -x \
  && sudo chown -R coq:coq /home/coq/demo \
  && coq_makefile -f _CoqProject -o Makefile \
  && make"]
