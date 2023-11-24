libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/SecurityManager.java";

// imports

import java/io/FileDescriptor;
import java/lang/Object;
import java/lang/SecurityManager;
import java/lang/String;
import java/lang/Thread;
import java/lang/ThreadGroup;
import java/net/InetAddress;
import java/security/Permission;
import java/security/AccessControlContext;


// automata

automaton SecurityManagerAutomaton
(
)
: LSLSecurityManager
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        LSLSecurityManager,
    ];

    shift Initialized -> self by [
        // instance methods
        checkAccept,
        checkAccess (LSLSecurityManager, Thread),
        checkAccess (LSLSecurityManager, ThreadGroup),
        checkConnect (LSLSecurityManager, String, int),
        checkConnect (LSLSecurityManager, String, int, Object),
        checkCreateClassLoader,
        checkDelete,
        checkExec,
        checkExit,
        checkLink,
        checkListen,
        checkMulticast (LSLSecurityManager, InetAddress),
        checkMulticast (LSLSecurityManager, InetAddress, byte),
        checkPackageAccess,
        checkPackageDefinition,
        checkPermission (LSLSecurityManager, Permission),
        checkPermission (LSLSecurityManager, Permission, Object),
        checkPrintJobAccess,
        checkPropertiesAccess,
        checkPropertyAccess,
        checkRead (LSLSecurityManager, FileDescriptor),
        checkRead (LSLSecurityManager, String),
        checkRead (LSLSecurityManager, String, Object),
        checkSecurityAccess,
        checkSetFactory,
        checkWrite (LSLSecurityManager, FileDescriptor),
        checkWrite (LSLSecurityManager, String),
        getSecurityContext,
        getThreadGroup,
    ];

    // internal variables

    // utilities

    @AutoInline @Phantom proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    @AutoInline @Phantom proc _throwIAE (): void
    {
        action THROW_NEW("java.lang.IllegalArgumentException", []);
    }


    proc _do_checkPermission (perm: Permission): void
    {
        if (action SYMBOLIC("boolean"))
            action THROW_NEW("java.security.AccessControlException", [
                "access denied " /* + action OBJECT_TO_STRING(perm) */,
                perm
            ]);
    }


    // constructors

    constructor *.LSLSecurityManager (@target self: LSLSecurityManager)
    {
        _do_checkPermission(
            action DEBUG_DO("new RuntimePermission(\"createSecurityManager\")")
        );
    }


    // static methods

    // methods

    fun *.checkAccept (@target self: LSLSecurityManager, host: String, port: int): void
    {
        if (host == null)
            _throwNPE();

        // 'host' correctness check is too complex
        if (action SYMBOLIC("boolean"))
            _throwIAE();

        _do_checkPermission(
            null // #todo
        );
    }


    fun *.checkAccess (@target self: LSLSecurityManager, t: Thread): void
    {
        if (t == null)
            action THROW_NEW("java.lang.NullPointerException", ["thread can't be null"]);

        // #todo: check thread group?

        _do_checkPermission(
            null // #todo
        );
    }


    fun *.checkAccess (@target self: LSLSecurityManager, g: ThreadGroup): void
    {
        if (g == null)
            action THROW_NEW("java.lang.NullPointerException", ["thread group can't be null"]);

        // #todo: check thread group?

        _do_checkPermission(
            null // #todo
        );
    }


    fun *.checkConnect (@target self: LSLSecurityManager, host: String, port: int): void
    {
        if (host == null)
            action THROW_NEW("java.lang.NullPointerException", ["host can't be null"]);

        // host correctness check is too complex
        if (action SYMBOLIC("boolean"))
            _throwIAE();

        _do_checkPermission(
            null // #todo
        );
    }


    fun *.checkConnect (@target self: LSLSecurityManager, host: String, port: int, context: Object): void
    {
        if (host == null)
            action THROW_NEW("java.lang.NullPointerException", ["host can't be null"]);

        // 'host' correctness check is too complex
        if (action SYMBOLIC("boolean"))
            _throwIAE();

        _do_checkPermission(
            null // #todo
        );
    }


    fun *.checkCreateClassLoader (@target self: LSLSecurityManager): void
    {
        _do_checkPermission(
            null // #todo
        );
    }


    fun *.checkDelete (@target self: LSLSecurityManager, file: String): void
    {
        if (file == null)
            _throwNPE();

        // 'action' check during construction of a FilePermission object does not throw an exception

        _do_checkPermission(
            null // #todo
        );
    }


    fun *.checkExec (@target self: LSLSecurityManager, cmd: String): void
    {
        if (cmd == null)
            _throwNPE();

        // 'action' check during construction of a FilePermission object does not throw an exception

        _do_checkPermission(
            null // #todo
        );
    }


    fun *.checkExit (@target self: LSLSecurityManager, status: int): void
    {
        _do_checkPermission(
            null // #todo
        );
    }


    fun *.checkLink (@target self: LSLSecurityManager, lib: String): void
    {
        if (lib == null)
            _throwNPE();

        _do_checkPermission(
            null // #todo
        );
    }


    fun *.checkListen (@target self: LSLSecurityManager, port: int): void
    {
        _do_checkPermission(
            null // #todo
        );
    }


    fun *.checkMulticast (@target self: LSLSecurityManager, maddr: InetAddress): void
    {
        if (maddr == null)
            _throwNPE();

        _do_checkPermission(
            null // #todo
        );
    }


    fun *.checkMulticast (@target self: LSLSecurityManager, maddr: InetAddress, ttl: byte): void
    {
        if (maddr == null)
            _throwNPE();

        _do_checkPermission(
            null // #todo
        );
    }


    fun *.checkPackageAccess (@target self: LSLSecurityManager, pkg: String): void
    {
        if (pkg == null)
            _throwNPE();

        _do_checkPermission(
            null // #todo
        );
    }


    fun *.checkPackageDefinition (@target self: LSLSecurityManager, pkg: String): void
    {
        if (pkg == null)
            _throwNPE();

        _do_checkPermission(
            null // #todo
        );
    }


    fun *.checkPermission (@target self: LSLSecurityManager, perm: Permission): void
    {
        if (perm == null)
            _throwNPE();

        _do_checkPermission(perm);
    }


    fun *.checkPermission (@target self: LSLSecurityManager, perm: Permission, context: Object): void
    {
        if (context is AccessControlContext)
        {
            if (perm == null)
                _throwNPE();

            _do_checkPermission(perm);
        }
        else
        {
            action THROW_NEW("java.lang.SecurityException", []);
        }
    }


    fun *.checkPrintJobAccess (@target self: LSLSecurityManager): void
    {
        _do_checkPermission(
            null // #todo
        );
    }


    fun *.checkPropertiesAccess (@target self: LSLSecurityManager): void
    {
        _do_checkPermission(
            null // #todo
        );
    }


    fun *.checkPropertyAccess (@target self: LSLSecurityManager, key: String): void
    {
        _do_checkPermission(
            null // #todo
        );
    }


    fun *.checkRead (@target self: LSLSecurityManager, fd: FileDescriptor): void
    {
        _do_checkPermission(
            null // #todo
        );
    }


    fun *.checkRead (@target self: LSLSecurityManager, file: String): void
    {
        _do_checkPermission(
            null // #todo
        );
    }


    fun *.checkRead (@target self: LSLSecurityManager, file: String, context: Object): void
    {
        _do_checkPermission(
            null // #todo
        );
    }


    fun *.checkSecurityAccess (@target self: LSLSecurityManager, _target: String): void
    {
        if (_target == null)
            _throwNPE();

        if (action CALL_METHOD(_target, "isEmpty", []))
            _throwIAE();

        _do_checkPermission(
            null // #todo
        );
    }


    fun *.checkSetFactory (@target self: LSLSecurityManager): void
    {
        _do_checkPermission(
            null // #todo
        );
    }


    fun *.checkWrite (@target self: LSLSecurityManager, fd: FileDescriptor): void
    {
        _do_checkPermission(
            null // #todo
        );
    }


    fun *.checkWrite (@target self: LSLSecurityManager, file: String): void
    {
        _do_checkPermission(
            null // #todo
        );
    }


    fun *.getSecurityContext (@target self: LSLSecurityManager): Object
    {
        result = action SYMBOLIC("java.security.AccessControlContext");
        action ASSUME(result != null);
    }


    @Phantom fun *.getThreadGroup (@target self: LSLSecurityManager): ThreadGroup
    {
        // NOTE: using the original method
    }

}
