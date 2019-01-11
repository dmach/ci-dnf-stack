import re
import sys

import behave

from common import *


@behave.step("I execute dnf with args \"{args}\"")
def when_I_execute_dnf_with_args(context, args):
    cmd = " ".join(context.dnf.get_cmd(context))
    cmd += " " + args.format(context=context)
    context.dnf["rpmdb_pre"] = get_rpmdb_rpms(context.dnf.installroot)
    context.cmd = cmd
    context.cmd_exitcode, context.cmd_stdout, context.cmd_stderr = run(cmd, shell=True)


@behave.given("I enable plugin \"{plugin}\"")
def given_enable_plugin(context, plugin):
    if "plugins" not in context.dnf:
        context.dnf["plugins"] = []
    if plugin not in context.dnf["plugins"]:
        context.dnf["plugins"].append(plugin)


@behave.step("I execute \"{command}\" with args \"{args}\"")
def when_I_execute_command_with_args(context, command, args):
    cmd = command + " " + args
    context.cmd = cmd
    context.cmd_exitcode, context.cmd_stdout, context.cmd_stderr = run(cmd, shell=True)


@behave.then("the exit code is {exitcode}")
def then_the_exit_code_is(context, exitcode):
    if context.cmd_exitcode == int(exitcode):
        return
    print(context.cmd_stdout)
    print(context.cmd_stderr, file=sys.stderr)
    raise AssertionError("Command has returned exit code {0}: {1}".format(context.cmd_exitcode, context.cmd))


@behave.then("stdout contains \"{text}\"")
def then_stdout_contains(context, text):
    if re.search(text, context.cmd_stdout):
        return
    print(context.cmd_stdout)
    raise AssertionError("Stdout doesn't contain: %s" % text)


@behave.then("stdout is empty")
def then_stdout_is_empty(context):
    if not context.cmd_stdout:
        return
    print(context.cmd_stdout)
    raise AssertionError("Stdout is not empty, it contains: %s" % context.cmd_stdout)


@behave.then("stderr contains \"{text}\"")
def then_stderr_contains(context, text):
    if re.search(text, context.cmd_stderr):
        return
    print(context.cmd_stderr, file=sys.stderr)
    raise AssertionError("Stderr doesn't contain: %s" % text)


@behave.then("stderr is empty")
def then_stderr_is_empty(context):
    if not context.cmd_stderr:
        return
    print(context.cmd_stderr, file=sys.stderr)
    raise AssertionError("Stderr is not empty, it contains: %s" % context.cmd_stderr)


@behave.then("stdout is")
def then_stdout_is(context):
    if context.text.strip() == context.cmd_stdout.strip():
        return
    print(context.cmd_stdout)
    raise AssertionError("Stdout is not: %s" % context.text)


@behave.then("stdout contains lines")
def then_stdout_contains_lines(context):
    out_lines = context.cmd_stdout.split('\n')
    test_lines = context.text.split('\n')
    for line in test_lines:
        for outline in out_lines:
            if line == outline:
                break
        else:
            print(context.cmd_stdout)
            raise AssertionError("Stdout doesn't contain line: %s" % line)
