deallocate all;
 -- VIEWS 
create or replace view word_view as
	select d.id, d.word, d.def, s.name as subject, u.name as unit, c.name as category 
	from definition as d, subjects as s, units as u, categories as c
	where s.id = u.subject AND u.id = d.unit AND c.id = d.category;

-- PREPARED QUERIES
prepare update_word(int, varchar, varchar) as 
	UPDATE definition 
		set word = $2, def = $3
		where id = $1;

-- word, def, subject, unit
/*prepare add_word(varchar, varchar, varchar, varchar) as
	with s as (
		select id from subjects where name = $3
	), 
	u as (
		select id from units where name = $4 and subject = (select id from s)
	)
	insert into definition (word, def, unit) select $1 as word, $2 as def, (select id from u) as unit;*/

CREATE OR REPLACE FUNCTION add_word(word varchar, def varchar, subject varchar, unit varchar, category varchar) 
RETURNS void as $$
BEGIN
	with s as (
		select id from subjects as s where s.name = $3
	), 
	u as (
		select id from units as u where u.name = $4 and u.subject = (select id from s)
	),
	c as (
		select id from categories as c where c.name = $5
	)
	insert into definition (word, def, unit, category) select $1 as word, $2 as def, (select id from u) as unit, (select id from c) as category;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION del_word(word_id int) RETURNS void as $$
BEGIN
	delete from definition as d where d.id = word_id;
END;
$$ LANGUAGE plpgsql;

/*prepare unit_list(varchar) as
	with s as (
		select id from subjects where name = $1
	)
	select name from units where subject = (select id from s);*/

CREATE OR REPLACE FUNCTION unit_list(sub varchar)
RETURNS TABLE(name varchar) as $$
BEGIN
	RETURN QUERY
		with s as (
			select id from subjects where subjects.name = $1
		)
		select units.name from units where subject = (select id from s);
END;
$$ LANGUAGE plpgsql;
-- PL/PGSQL
/*
helper function for test_word
*/
-- CREATE OR REPLACE FUNCTION test_word1(unit varchar)
-- RETURNS TABLE(word varchar, def varchar) as $$
-- BEGIN
-- 	RETURN QUERY 
-- 		with s as (
-- 		select id from units where name = $1
-- 		)
-- 		select d.word, d.def from definition as d where 
-- 			d.subject = (select id from s)
-- 			d.unit = (select id from s) 
-- 			and d.category = (select id from c)
-- 		order by random() limit 1;		
-- END;
-- $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION test_word1(subject varchar, unit varchar, category varchar)
RETURNS TABLE(word varchar, def varchar) as $$
BEGIN
	RETURN QUERY
		select v.word, v.def from word_view as v where
			v.subject = $1 and 
			v.unit = $2 and 
			v.category = $3
		order by random() limit 1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION test_word(subject varchar, unit varchar, category varchar, w_or_d boolean) 
RETURNS TABLE(q varchar, a varchar) as $$
BEGIN 
	IF w_or_d THEN
		RETURN QUERY 
			with t as(
				select * from test_word1(subject, unit, category)
			)
			select word as q, def as a from t;
	ELSE
		RETURN QUERY 
			with t as(
				select * from test_word1(subject, unit, category)
			)
			select def as q, word as a from t;
	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_unit(subjectname varchar, unitname varchar)
RETURNS void as $$
BEGIN
	with s as (
		select id from subjects as s where s.name = subjectname
	)
	insert into units (name, subject) select $2 as name, (select id as subject from s);
END;
$$ LANGUAGE plpgsql