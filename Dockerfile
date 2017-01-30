FROM norionomura/sourcekit:302
MAINTAINER Maciej Kujalowicz <maciej.kujalowicz@gmail.com>

# Environment Variables

ENV SWIFTLINT_REVISION="85abab13b94d569ba7d85ee28dbf1d35cb606b0d" \
	SWIFTLINT_BUILD_DIR="/swiftlint_build" \
	LINT_WORK_DIR="/swiftlint"

# Clone the Swiftlint project and build it

WORKDIR "${SWIFTLINT_BUILD_DIR}"	

RUN git clone https://github.com/realm/SwiftLint.git . \
	&& git checkout -f -q "${SWIFTLINT_REVISION}" \
	&& swift build -c release
	
# Move built artifacts to Swift install locations	
	
WORKDIR "${SWIFTLINT_BUILD_DIR}"

RUN	cd .build/release \
	&& mv swiftlint /usr/bin/ \
	&& mv *.so /usr/lib/swift/linux/x86_64/ \
	&& mv *.swiftmodule /usr/lib/swift/linux/x86_64/ \
	&& cd / \
	&& rm -rf "${SWIFTLINT_BUILD_DIR}"

RUN swiftlint version

RUN echo "${SWIFT_INSTALL_DIR}"

VOLUME ${LINT_WORK_DIR}
WORKDIR ${LINT_WORK_DIR}

ENTRYPOINT ["swiftlint"]
CMD ["lint"]
