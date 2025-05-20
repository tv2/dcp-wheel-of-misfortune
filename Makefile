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

define persona_kundecenter
	@echo "Submitting a message as the "Kundecenter" persona to Slack."
	@curl -X POST -H 'Content-type: application/json' --data '{ \
		"username": "Kurt Undecenter", \
		"icon_url": "https://upload.wikimedia.org/wikipedia/commons/8/8f/Phone_calls_can_cause_anxiety_in_select_individuals..jpg", \
		"text": $(1), \
		"channel": "$(SLACK_CHANNEL)", \
	}' "$(SLACK_WEBHOOK)"
	@echo
endef

define persona_clear_screen
  @echo "Clearing the screen in Slack"
	@curl -X POST -H 'Content-type: application/json' --data '{ \
		"username": "Preben Edel", \
		"icon_url": "https://upload.wikimedia.org/wikipedia/commons/2/25/Workers_disinfect_schools_against_coronavirus_in_Bojnord_2020-02-26_08.jpg", \
		"text": "Clearing the screen...\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n:broom:", \
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

# play-is-timing-out
.PHONY: incident-play-is-timing-out
incident-play-is-timing-out: check-aws-context get-secret
	@echo "Initializing play-is-timing-out incident..."
	$(call persona_operations_center, ":alert: *MAJOR INCIDENT* :alert:\n\nCustomers are unable to access play.tv2.dk.\nDevelopers from the product team and platform team has been contacted.")
	$(call persona_developer, "I checked but the application looks healthy... I do not know why. Need help from DCP...")
	$(call persona_kundecenter, "I am getting a lot of calls from customers who cannot access play.tv2.dk. They say that it is stuck loading for a long while but sometimes it DOES load successfully...")

# multiple-applications-failing
.PHONY: incident-multiple-applications-failing
incident-multiple-applications-failing: check-aws-context get-secret
	@echo "Initializing multiple-applications-failing incident..."
	$(call persona_operations_center, ":alert: *MAJOR INCIDENT* :alert:\n\nSeveral product teams are reporting failures in their critical applications.\nDevelopers from the product team and platform team has been contacted.")
	$(call persona_developer, "I checked the application multiple pods seem to be stuck in pending. Other developers are reporting the same issue. I do not know why. Need help from DCP...")

# waf-rate-limit
.PHONY: incident-waf-rate-limit
incident-waf-rate-limit: check-aws-context get-secret
	@echo "Initializing waf-rate-limit incident..."
	$(call persona_operations_center, ":alert: *MAJOR INCIDENT* :alert:\n\nCustomers are reporting issues accessing content on play.tv2.dk.\nDevelopers from the product team and platform team has been contacted.")
	$(call persona_developer, "I am fairly sure the issue is related to the WAF rate limit. I have no idea how to increase it :oldshrug: please help us DCP.")

# no-observability
.PHONY: incident-no-observability
incident-no-observability: check-aws-context get-secret
	@echo "Initializing no-observability incident..."
	$(call persona_developer, "*DIRECT MESSAGE*\n\nHi!\nim looking at my dashboard for my critical application but it seems it is not getting any data?? Can you check what i have misconfigured?")

# terminating-pvc
.PHONY: incident-terminating-pvc
incident-terminating-pvc: check-aws-context get-secret
	@echo "Initializing terminating-pvc incident..."
	$(call persona_developer, "*DIRECT MESSAGE*\n\nHi!\nim trying to roll out a new version of my application but the new pods never come up. what have i done wrong????")

# tenant-applications-never-load
.PHONY: incident-tenant-applications-never-load
incident-tenant-applications-never-load: check-aws-context get-secret
	@echo "Initializing tenant-applications-never-load incident..."
	$(call persona_operations_center, ":alert: *MAJOR INCIDENT* :alert:\n\nCritical TV 2 Play application inaccessible.\nDevelopers from the product team and platform team has been contacted.")
	$(call persona_developer, "I checked but the application seems to be healthy, but when accessing it i get the error below... I do not know why. Need help from DCP...")

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

###
# Misc
###

.PHONY: clear-slack
clear-slack: check-aws-context get-secret
	$(call persona_clear_screen)
