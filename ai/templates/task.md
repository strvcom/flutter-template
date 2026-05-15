<vision>
## What are we building?
[Clear description of what this feature/system does]

## Why are we building it?
[Business value, user problem being solved]

## How does it connect to everything else?
[Where does data flow from/to? What other parts of the system does this touch?]

## What does success look like?
[Concrete outcome - what should the user be able to do when this is done?]
</vision>

<foundation>
## Data Model

### Entities
[Define the core entities, their fields, and relationships]

### Seed Data
[Initial data needed]

## Dependencies

### Requires (inputs)
- [What existing data/APIs/services does this need?]

### Provides (outputs)
- [What does this expose to other parts of the system?]

### Third-party integrations
- [External APIs, services, data sources needed]
</foundation>

<implementation>
## Core Behavior
[Describe the main flows and logic]

## Key Screens/Components
[List main UI pieces without being overly prescriptive]

## Edge Cases
[What happens when things go wrong? Empty states? Errors?]
</implementation>

<constraints>
## Must Have
- [Non-negotiable requirement]

## Must NOT Have
- [What to avoid - tech debt, patterns to skip]

## Follow Existing Patterns From
- [Reference file/component to match]
</constraints>

<quality_gates>
## No Gaping Problems
- [ ] [Check that prevents future refactoring]

## Ready to Ship
- [ ] [What "good enough" looks like for v1]
</quality_gates>

<questions>
## Clarify Before Starting

> If any of the following are unclear or missing, **ASK before implementing**. Do not assume or invent solutions.

- [ ] Is the data model complete? Any missing fields or relationships?
- [ ] Are all dependencies available and accessible?
- [ ] Are there existing patterns in the codebase to follow?
- [ ] What's the priority - speed to ship or polish?
</questions>

<context>
## Reference Materials
- [Link to relevant PRD, wireframes, or specs]

## Codebase Location
- Feature path: `[where this code should live]`
- Related code: `[existing code to reference]`
</context>
