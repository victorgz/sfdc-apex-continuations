# Apex Continuations: Implementation and testing in Aura and Lighting Web Components

## Installation with SFDX

1. Set up your environment. If you haven't done it yet, follow the steps in the Quick Start: [Lightning Web Components Trailhead project](https://trailhead.salesforce.com/content/learn/projects/quick-start-lightning-web-components/):

- Enable a Dev Hub in your Trailhead Playground
- Install the Salesforce CLI
- Install Visual Studio Code
- Install the Visual Studio Code Salesforce extensions, including the Lightning Web Components extension

2. Authenticate with your hub org and provide it with an alias (myhuborg in the command below):

```
sfdx force:auth:web:login -d -a myhuborg
```

3. Clone the repository:

```
git clone https://github.com/victorgz/sfdc-apex-continuations
cd sfdc-apex-continuations
```

4. Create a scratch org and provide it with an alias (continuations_scratch in the command below):

```
sfdx force:org:create -s -f config/project-scratch-def.json -a continuations_scratch
```

5. Push the app to your scratch org:

```
sfdx force:source:push
```

6. Open the scratch org:

```
sfdx force:org:open
```

Now the code is ready in your scratch org, and you can test the different Lightning Web Components inside your pages

## Contributing

Pull requests are welcome. For major changes, please [open an issue](https://github.com/victorgz/sfdc-apex-continuations/issues) first to discuss what you would like to change.
