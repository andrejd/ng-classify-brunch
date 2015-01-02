## ng-classify-brunch
Adds support for [ng-classify](https://github.com/CaryLandholt/ng-classify) to
[brunch.io](http://brunch.io)

### Installation

Install the plugin via npm with npm install --save ng-classify-brunch.

Or, do manual install by adding text below to your package file inside your `brunch` application:

`"ng-classify-brunch": "git+https://github.com/AndrejD/ng-classify-brunch.git",`

### Usage

Plugin will be called before compilation of each `.coffee` file and it will transform
contained classes to AngularJS declaration, e.g. class declaration of controller
```coffee
class User extends Controller
    constructor: ($scope, myService) ->
        $scope.myMethod = myService.myMethod()
```
will be
transformed into this code:

```coffee
angular.module('app').controller('userController', ['$scope', 'myService', function ($scope, myService) {
    $scope.myMethod = myService.myMethod();
}]);
```

See more information about `ng-classify` [here](https://github.com/CaryLandholt/ng-classify).


### Configuration

There are some options that allow changing plugin defaults. You can add these
settings to `brunch-config.json` file:

```coffeescript
config =
    plugins:
        ngclassify:
            foldersToModules:true
            modulesRoot:'app/modules/'
            appName:'app'

```
Under `ngclassify` you can add all options described on
[ng-classify](https://github.com/CaryLandholt/ng-classify) repository.
You can also change properties dynamically based on file path by defining
function like in next example:

```coffee
config =
    plugins:
        ngclassify: (path) ->
            # each return statement is strong coupled to project folder tree
            # 'appName' value must be unique
            return appName: 'admin' if path.indexOf('admin') != -1
            return appName: 'dashboard' if path.indexOf('dashboard') != -1
            return appName: 'app' if path.indexOf('app') != -1
```

### Bonus feature for domain folder structure :)

By setting `foldersToModules:true` and root directory for modules, e.g.: `modulesRoot:'app/modules/'`
under plugin settings, plugin will extract `appName` from file path and will change options passed to
ng-classify accordingly. It will also inject code into compiled file for auto creation of module
if module with that name does not exist yet. This way you do not need to specify you module
explicitly.

If you use domain folder structure for your project then you just need to define your controllers
and other settings in form of classes and after file concatenation all needed modules will be
created on the fly.

You can still create modules manually, but in that case make sure that
file with module definition gets concatenated before files that rely on that module.

```coffee
app
    assets
    modules
        admin
            admin.coffee
            admin.html
        user
            user.coffee
            user.html
        dashboard
            dashboard.coffee
        app.coffee
    styles
    ...


```
Controller defined in `admin.coffee` file will be assigned to module `admin` (folder name) and `admin`
module will be created on the fly if it does not exist yet.






## License

The MIT License (MIT)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
