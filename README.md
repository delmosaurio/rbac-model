# RBAC model

## Funciones


**Obtiene roles para un usuario**

```
fn_user_roles(
  _user_id integer
)
```

**Actualiza (insert/update) el acceso para un usuario y un objecto**

```
fn_revoke_user_object(
  _user_id integer,  _object_id integer,  _access_grant integer,  _access_deny integer
)
```

**Elimina la relación entre un usuario dado y un objeto**

*NOTA: La relación entre usuario/objecto debe de ser directa en el caso de que el objecto esté relacionado con un role que posee el usuario el mismo seguirá vigente*

```
fn_unlink_user_object(
  _user_id integer,  _object_id integer
)
```

**Actualiza (insert/update) el acceso para un role y un objecto**

```
fn_revoke_role_object(
  _role_id integer,  _object_id integer,  _access_grant integer,  _access_deny integer
)
```

**Elimina la relación entre un role dado y un objeto**

```
fn_unlink_role_object(
  _role_id integer,  _object_id integer
)
```

**Obtiene el tipo de acceso que posee un role para un objecto dado de forma:**

***(OR access_grant) AND (OR access_deny)***

```
fn_access_role_object(
  _role_id integer,  _object_id integer
)
```

**Obtiene el tipo de acceso que posee un perfil para un objecto dado de forma:**

***(OR access_grant) AND (OR access_deny)***

```
fn_access_profile_object(
  _profile_id integer,  _object_id integer
)
```

**Obtiene el tipo de acceso que posee un usuario para un objecto dado de forma:**

***(OR access_grant) AND (OR access_deny)***

```
fn_access_user_object(
  _user_id integer,  _object_id integer
)
```

**Relaciona un role a un perfil**

```
fn_add_role_profile(
  _role_id integer, _profile_id integer
)
```

**Elimina la relación para un role y un perfil**

```
fn_remove_role_profile(
  _role_id integer, _profile_id integer
)
```

## VIEWS
  - v_users
  - v_profiles_roles
  - v_user_objects
  - v_roles_objects