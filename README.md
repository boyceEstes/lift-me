# lift-me

![example workflow](https://github.com/boyceEstes/lift-me/.github/workflows/ci.yml/badge.svg)


## Routine and Exercise Core Specs
### Narrative #1
Create custom routine

#### User Story
```
As a user
I want to make up a routine as I go along
So I want to do a routine is empty and add exercises to it
```

```
As a user that has created a custom routine
I want to save the exercises (in order) with a name
So I can do them again later
```

#### Acceptance Criteria
```
Given a user
When the user creates a custom routine
Then display an active routine screen with no exercises
```

```
Given a user that is in an active routine
And the user has entered exercise records
And the exercise records have filled set records
When the routine saves the custom routine
Then display a screen asking if the user wants to save the custom routine

Given a screen asking if the user wants to save the custom routine
When the user confirms to save the routine
Then display a screen for the user to name the routine

Given a screen for the user to edit the name of the custom routine
When the user confirms the name
Then display the Home Screen (where you initially went to start the custom routine)
```


### Narrative #2
Add routine record from saved routine

#### User Story
```
As a user that has created routines
I want to be able to select a premade routine
So I can easily do a routine
```

#### Acceptance Criteria

```
Given a user that has some premade routines
When the user taps a routine
Then display the active routine screen and display exercises associated with tapped routine
```


### Narrative #3
Create a routine

#### User Story

```
As a user
I want to create a routine
So I can have one ready when I get to the gym
```

```
As a user that is in the process of creating a routine
I want to discard this routine
So I can start again from nothing
```

#### Acceptance Criteria
```
Given a user
When the user taps to create a routine
Then display a routine creation screen

Given a user is on the routine creation screen
And the user has not added any required information
When the user tries to save
Then display error saying that you cannot save an empty routine
```

```
Given a user is on the routine creation screen
And the user has added required information
When the user taps the discard routine button
Then display a confirmation alert before allowing the user to delete the routine
And present the Home Screen (previous screen before making the routine)

Given a user is on the routine creation screen
And the user has NOT added required information
When the user taps the discard routine button
Then present the Home Screen (previous screen before making the routine) - No confirmation
```

### Narrative #4
Remove a routine

#### User Story
```
As a user with saved routines
I want to remove unused routines
So I can unclutter my saved routines
```

#### Acceptance Criteria
```
Given a user with saved routines
When a user removes a routine
Then remove the routine
And modify routine records to not point to any routine (do not delete them)
```

## Terminology

### Naming
I'm splitting up the names method calls for infrastructure layer from the controller to coordinator for easier distinction since they would be so similar.

For controllers (named repositories in the codebase (which will usually be the below use-cases)):
- Save - CREATE
- Load - READ
- Update - UPDATE
- Remove - DELETE

For Infrastructure layer (any caching, networking, etc commands):
- Create - CREATE
- Read - Read
- Update - UPDATE
- Delete - DELETE


### Testing Naming Conventions

Naming will be done so that we can easily tell what the system under test (sut) is, the test scenario, and the expected outcome

```
func test_<sut>_<conditions-of-test>_<outcome-of-test>
```

```
func test_routineRepository_init_doesNotMessageStore()
```


## Use Cases

### Save Routine Use Case
Can be used when saving active record routine as well as precreating routines

#### Data:
- Routine

#### Primary course (happy path):
1. Execute "read routines with name or exercises" command to find duplicate cached routines
2. System receives no results with the same routine information
3. Execute "Create routine" command with above data
4. System caches routine
5. System delivers success message

#### Read routines with name error course (sad path):
1. System delivers error

#### Create routine system error course (sad path):
1. System delivers error

#### Duplicate routine name (but different exercises) (sad path):
1. System receives results with routine's name
2. System delivers error - duplicate name

#### Duplicate routine exercises (but different name) (sad path):
1. System receives results with routine's exercises
2. System delivers error - routine already exists, and include duplicate's name

#### Duplicate routine exercises and name (sad path):
1. System receives results with routine's exercises and name
2. System delivers error - routine already exists, and include duplicate's name

#### Create in Cache Behavior
- [ ] To empty cache works
- [ ] To non-empty cache overrides previous value

---

### Load Routines Use Case

#### Primary course (happy path):
1. Execute "Read all routines" command
2. System fetches all routines
3. System delivers routines

#### System error course (sad path):
1. System delivers error

#### Retrieve From Cache Behavior
- [x] Empty cache returns empty
- [x] Empty cache twice returns empty (no side-effects)
- [x] Non-empty cache returns data
- [x] Non-empty cache twice returns data (no side-effects)

---

### Save Routine Record Use Case
If the user chooses not to save the routine, this will be called to save the routine information

#### Data:
- RoutineRecord

#### Primary course (happy path):
1. Execute "Create Or Update Routine Record" command with above data
2. System fetches any routine records cached with the same ID
3. System updates if there is an existing record or inserts if this record is unique
2. System delivers success message

#### System error course (sad path):
1. System delivers error

---

### Load Routine Record Use Case

#### Data:
- ID: UUID

#### Primary course (happy path):
1. Execute "Read Routine Record" command with above data
2. System fetches cached routine record with the same ID
3. System delivers cached routine record

#### Cannot find ID (sad path):
1. System delivers error

#### System error:
1. System delivers error


---


### Save Active Routine Record Use Case
#### Data:
- RoutineRecord

#### Primary course (happy path):
1. Execute "Save Routine Record Use Case" command
2. Execute "Create Active Routine Record ID" command
3. System replaces any active routine record value with provided ID
3. System delivers success message

#### Cache Routine Record Use Case error course (sad path):
1. System delivers error

#### Cache Active Routine Record ID Use Case error course (sad path):
1. System delivers error


---


### Load Active Routine Record Use Case

#### Data:

#### Primary course (happy path):
1. Execute "Read and delete active routine record ID" command
2. System clears active routine record ID
3. System returns previous active routine record ID
3. Execute "Load Active Routine Record" command
4. System delivers cached routine record

#### No Active Routine Record course (happy path):
1. Execute "Read and delete active routine record ID" command
2. System returns no active routine record ID
3. System delivers nil

#### Load Active Routine Record error course:
1. System delivers Error

---
