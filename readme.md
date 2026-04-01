# toolbox (tbx)

This is a collection of code that is written to specifically make games and make that easier.

This code is modular to an extent, some modules may depend on others, but generally you can extract what you need to do what you need. 

There is an engine submodule which helps you set up a window and do some basic rendering, this is useful when you're doing something generic that requires graphics, and don't want to have to go through the "making my own wrapper around opengl so that it doesn't take 10 minutes to get a triangle going" thing that can be annoying when you want results and not control. 

## usage

Create a directory for the project you want to use tbx with, create your source directory (I usually call it src) and then add this repo in there (as submodule, or just download and plunk it in). Now I create a `build.jai` file of this form: 

```jai
OUTPUT_EXECUTABLE_NAME :: "change_me";

#run {
    set_build_options_dc(.{do_output = false});

    args := get_build_options().compile_time_command_line;
    target_arm := array_find(args, "-arm64");

    cpu_target := CPU;
    if array_find(args, "-x64")  cpu_target = .X64;
    if target_arm                cpu_target = .ARM64;

    make_directory_if_it_does_not_exist("bin", recursive = true);

    w := compiler_create_workspace("Target workspace");
    options := get_build_options(w);
    copy_commonly_propagated_fields(get_build_options(), *options);
    options.cpu_target = cpu_target;
    options.output_executable_name = OUTPUT_EXECUTABLE_NAME;
    options.output_path = "bin/";
    if target_arm {
        options.backend = .LLVM;
        options.llvm_options.target_system_features = "+lse";
    }

    import_path: [..] string;
    array_add(*import_path, ..options.import_path);
    array_add(*import_path, "src/");
    options.import_path = import_path;

    set_build_options(options, w);

    compiler_begin_intercept(w);
    add_build_file("src/main.jai", w);
    while true {
        message := compiler_wait_for_message();
        if message.kind == .ERROR   exit(1);
        if message.kind == .COMPLETE break;
    }
    compiler_end_intercept(w);
};

#import "Basic";
#import "Compiler";
#import "File";
#import "String";

```

You can now just run `jai build.jai` and tbx is ready to be `#import`ed into your `main.jai` file.

Note that toolbox is a collection of jai modules stored as git submodules (yes I know that's a lot of modulation, but remember that git submodules are just a thing to help us clone components that we need). Some modules stand on their own, while others depend on other modules. We use submodules because if we want to use the json library, we could just clone that part of toolbox and just use that. 

At the same time jai compiles fast, and so it's totally feasible to just clone this entire thing and start moving without incurring a large compilation cost (as you might in something like c++).


## naming

Our modules usually are named as verbs, so instead of naming modules as "light_baker", we name them "light_baking" this is done puposefully because in general the module that we're talking about here might not provide a single top level system called Light_Baker, but may provide many different functions and structs all related to doing light baking, maybe there's a pbr light baker and maybe there's a classic diffuse & specular light baker, so the module is referred to as light baking because it helps you do light baking, it's not trying to make you use a particular light baker.

