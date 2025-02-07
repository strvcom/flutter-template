# Patrol

## Quick patrol cookbook

More can be found [here](https://patrol.leancode.co/finders/usage).


```
expect($("Can't touch this"), findsNothing);
expect($(Card), findsNWidgets(3));
```


```
await $('Log in').waitUntilVisible();
```


```
await $('index: 100').scrollTo(view: $(#listView2).$(Scrollable)).tap();
```
