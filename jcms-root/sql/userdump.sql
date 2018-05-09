--
-- dump users in a file useful for import into a Lyris list
--

\pset fieldsep ' '
\t
\a
\o users.txt
SELECT email,firstname,lastname FROM users;

