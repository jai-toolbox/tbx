# toolbox (tbx)

This is a collection of code that is written to specifically make games and make that easier.

This code is modular to an extent, some modules may depend on others, but generally you can extract what you need to do what you need. 

There is an engine submodule which helps you set up a window and do some basic rendering, this is useful when you're doing something generic that requires graphics, and don't want to have to go through the "making my own wrapper around opengl so that it doesn't take 10 minutes to get a triangle going" thing that can be annoying when you want results and not control. 

## setting up a new project

```
git submodule add git@github.com:jai-toolbox/shaders.git data/shaders
git submodule add git@github.com:jai-toolbox/tbx.git src/tbx
git submodule update --init --recursive
```

## usage

Create a directory for the project you want to use tbx with, create your source directory (I usually call it src) and then add this repo in there (as submodule, or just download and plunk it in). Now I create a `build.jai` file of this form: 

```jai
OUTPUT_EXECUTABLE_NAME :: "change_me";

#run {
    set_build_options_dc(.{do_output = false});

    make_directory_if_it_does_not_exist("bin", recursive = true);

    w := compiler_create_workspace("Target Program");
    options := get_build_options(w);
    options.output_executable_name = OUTPUT_EXECUTABLE_NAME;
    options.output_path = "bin/";

    import_path: [..] string;
    array_add(*import_path, ..options.import_path);
    array_add(*import_path, "src/");
    options.import_path = import_path;
    
    set_build_options(options, w);

    add_build_file("src/main.jai", w);
};

#import "Basic";
#import "Compiler";
#import "File";

```

You can now just run `jai build.jai` and tbx is ready to be `#import`ed into your `main.jai` file.

Note that toolbox is a collection of jai modules stored as git submodules (yes I know that's a lot of modulation, but remember that git submodules are just a thing to help us clone components that we need). Some modules stand on their own, while others depend on other modules. We use submodules because if we want to use the json library, we could just clone that part of toolbox and just use that. 

At the same time jai compiles fast, and so it's totally feasible to just clone this entire thing and start moving without incurring a large compilation cost (as you might in something like c++).

If you use git, then you can create this `.gitignore`

```
bin
.build
```


## naming

Our modules usually are named as verbs, so instead of naming modules as "light_baker", we name them "light_baking" this is done puposefully because in general the module that we're talking about here might not provide a single top level system called Light_Baker, but may provide many different functions and structs all related to doing light baking, maybe there's a pbr light baker and maybe there's a classic diffuse & specular light baker, so the module is referred to as light baking because it helps you do light baking, it's not trying to make you use a particular light baker.

## assets 

When you're starting development you usually have some data directory where you store all your asset files. When you need them you load them up by path directly, this works and is fine, but if you're a person that wants to distribute your executable, having to drag along a data directrory can be problematic. The main issue is that if you've purchased assets, then its very easy for people that use your program to steal the assets, for the most part this isn't an issue but if you purchased something and now other people can obtain that thing for free you can see the problem with that. The asset module allows you to turn these asset directories into a single binary package, which we can load inside the program, making it harder for assets to leak.

