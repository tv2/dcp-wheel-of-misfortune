SLACK_WEBHOOK := ""
SLACK_CHANNEL := ""
SECRET_ID := "dcp-wheel-of-misfortune"

.PHONY: check-aws-context
check-aws-context:
	@echo "Checking AWS CLI context..."
	@ACCOUNT_ID=$$(aws sts get-caller-identity --query Account --output text) && \
	if [ "$$ACCOUNT_ID" = "116172753206" ]; then \
		echo "AWS CLI context is set to the correct account (ID: $$ACCOUNT_ID)."; \
	else \
		echo "Error: AWS CLI context is not set to the correct account. Current account ID: $$ACCOUNT_ID."; \
		exit 1; \
	fi

.PHONY: get-secret
get-secret:
	$(eval SLACK_WEBHOOK := $(shell aws secretsmanager get-secret-value --secret-id $(SECRET_ID) --query SecretString --output text | jq -r '.SLACK_WEBHOOK'))
	$(eval SLACK_CHANNEL := $(shell aws secretsmanager get-secret-value --secret-id $(SECRET_ID) --query SecretString --output text | jq -r '.SLACK_CHANNEL'))
	@echo "SLACK_WEBHOOK and SLACK_CHANNEL loaded into Make variables."

###
# Personas
###

define persona_operations_center
  @echo "Submitting a message as the "Operations Center" persona to Slack."
	@curl -X POST -H 'Content-type: application/json' --data '{ \
		"username": "O. Centersen", \
		"icon_url": "https://live.staticflickr.com/4044/4257136773_704c0b0dd5_o.jpg", \
		"text": $(1), \
		"channel": "$(SLACK_CHANNEL)", \
	}' "$(SLACK_WEBHOOK)"
	@echo
endef

define persona_developer
	@echo "Submitting a message as the "Developer" persona to Slack."
	@curl -X POST -H 'Content-type: application/json' --data '{ \
		"username": "Uffe D. Viklersen", \
		"icon_url": "https://upload.wikimedia.org/wikipedia/commons/f/f5/RobGrindes-shrug-143px.png", \
		"text": $(1), \
		"channel": "$(SLACK_CHANNEL)", \
	}' "$(SLACK_WEBHOOK)"
	@echo
endef

###
# Incidents
###

# failing-payments
.PHONY: incident-failing-payments
incident-failing-payments: check-aws-context get-secret
	@echo "Initializing failing-payments incident..."
	$(call persona_operations_center, ":alert: *MAJOR INCIDENT* :alert:\n\nCustomers are unable to submit orders for new subscriptions.\nDevelopers from the product team and platform team has been contacted.")
	$(call persona_developer, "The payment service seems to time out on requests. I do not know why. Need help from DCP...")

###
# Building
###

.PHONY: build
build:
	docker build --no-cache -t $(SECRET_ID) .

.PHONY: run
run: build
	@echo
	@echo "Running the DCP Wheel of Misfortune application. Visit http://localhost:8080 to access it."
	@echo
	docker run -it --rm -p 8080:80 $(SECRET_ID)
