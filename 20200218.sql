--����� ���� ���� (leaf ==> root node(���� node))
--��ü ��带 �湮�ϴ°� �ƴ϶� �ڽ��� �θ� ��常 �湮(����İ� �ٸ���)
--������ : ��������
--������ : �����μ�

SELECT dept_h.*, LEVEL, LPAD(' ', (LEVEL-1)*4) || deptnm deptnm
FROM dept_h
START WITH deptnm = '��������'
CONNECT BY PRIOR p_deptcd = deptcd;

--ORACLE ���� ������ Ž�� ������ pre-order�̴�.

h_4;
create table h_sum as
select '0' s_id, null ps_id, null value from dual union all
select '01' s_id, '0' ps_id, null value from dual union all
select '012' s_id, '01' ps_id, null value from dual union all
select '0123' s_id, '012' ps_id, 10 value from dual union all
select '0124' s_id, '012' ps_id, 10 value from dual union all
select '015' s_id, '01' ps_id, null value from dual union all
select '0156' s_id, '015' ps_id, 20 value from dual union all

select '017' s_id, '01' ps_id, 50 value from dual union all
select '018' s_id, '01' ps_id, null value from dual union all
select '0189' s_id, '018' ps_id, 10 value from dual union all
select '11' s_id, '0' ps_id, 27 value from dual;

select *
FROM h_sum;

SELECT LPAD(' ', (LEVEL-1)*4) ||S_ID s_id, VALUE
FROM h_sum
START WITH s_id='0'
CONNECT BY PRIOR s_id = ps_id;

create table no_emp(
    org_cd varchar2(100),
    parent_org_cd varchar2(100),
    no_emp number
);
insert into no_emp values('XXȸ��', null, 1);
insert into no_emp values('�����ý��ۺ�', 'XXȸ��', 2);
insert into no_emp values('����1��', '�����ý��ۺ�', 5);
insert into no_emp values('����2��', '�����ý��ۺ�', 10);
insert into no_emp values('������ȹ��', 'XXȸ��', 3);
insert into no_emp values('��ȹ��', '������ȹ��', 7);
insert into no_emp values('��ȹ��Ʈ', '��ȹ��', 4);
insert into no_emp values('�����κ�', 'XXȸ��', 1);
insert into no_emp values('��������', '�����κ�', 7);

commit;

SELECT *
FROM no_emp;

--h_5
SELECT LPAD(' ',(LEVEL-1)*5) || ORG_CD org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd=parent_org_cd;

--������ ������ �� ���� ���� ��� ��ġ�� ���� ��� ��(pruning branch - ����ġ��)
--FROM -> START WITH, CONNECT BY -> WHERE
--1. WHERE : ���� ������ �ϰ� ���� ���� ����
--2. CONNECT BY : ���� ������ �ϴ� �������� ���� ����

--WHERE �� ����� : �� 9���� ���� ��ȸ�Ǵ°� Ȯ��
--WHERE �� (deptnm != ������ȹ��) : ������ȹ�θ� ������ 8���� �� ��ȸ�Ǵ� �� Ȯ��(������ȹ�� ������ ���̳� ��Ʈ�� ���)

SELECT LPAD(' ',(LEVEL-1)*5) || ORG_CD org_cd, no_emp
FROM no_emp
WHERE org_cd != '������ȹ��'
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd=parent_org_cd;

--CONNECT BY ���� ������ ���
--�����ϴ� �������� �ƿ� ������ �Ǿ������.
--������ȹ���� ������ �μ��� ������ ����� �ȵǾ������.
SELECT LPAD(' ',(LEVEL-1)*5) || ORG_CD org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd=parent_org_cd AND org_cd != '������ȹ��';

--CONNECT_BY_ROOT(�÷�) : �ش� �÷��� �ֻ��� ���� ����
--ex) �Խñ��� �ø��� �� �Ʒ��� ����� �޶� �Խñ��� �ֻ����� �ְ� ����� �� �Ʒ� ������ ����ؼ� Ȱ���Ѵ�.
SELECT LPAD(' ',(LEVEL-1)*5) || ORG_CD org_cd, no_emp,
       CONNECT_BY_ROOT(org_cd) root
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd=parent_org_cd;

--SYS_CONNECT_BY_PATH(�÷�, ������) : �ش� ���� �÷��� ���Ŀ� �÷� ���� ��õ, �����ڷ� �̾��ش�.
--�� �Լ��� �� ������ -�� ������ �ٱ� ������ LTRIM �� �ѽ�ó�� ���ȴ�.
SELECT LPAD(' ',(LEVEL-1)*5) || ORG_CD or_cd, no_emp,
       LTRIM(SYS_CONNECT_BY_PATH(org_cd,'-'),'-')PATH
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd=parent_org_cd;


--CONNECT_BY_ISLEAF : �ش� ���� LEAF �������(����� �ڽ��� ������)���� ���� [1.leaf, 0. no leaf]

SELECT LPAD(' ',(LEVEL-1)*5) || ORG_CD org_cd, no_emp,
       CONNECT_BY_ISLEAF leaf
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd=parent_org_cd;

--h6
create table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, 'ù��° ���Դϴ�');
insert into board_test values (2, null, '�ι�° ���Դϴ�');
insert into board_test values (3, 2, '����° ���� �ι�° ���� ����Դϴ�');
insert into board_test values (4, null, '�׹�° ���Դϴ�');
insert into board_test values (5, 4, '�ټ���° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (6, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (7, 6, '�ϰ���° ���� ������° ���� ����Դϴ�');
insert into board_test values (8, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (9, 1, '��ȩ��° ���� ù��° ���� ����Դϴ�');
insert into board_test values (10, 4, '����° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (11, 10, '���ѹ�° ���� ����° ���� ����Դϴ�');
commit;

select *
FROM board_test;


SELECT SEQ, LPAD(' ', (LEVEL-1)*4 ) || title title
FROM board_test
START WITH seq IN (1,2,4)
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq desc;

--�ٽ� Ǯ� ����
--�����ϴ� ��Ʈ�� �������̱� ������ start with���� �� ����� ������Ѵ�.
SELECT seq, LPAD(' ',(LEVEL-1)*4) || title title, DECODE(parent_seq, NULL, seq, parent_seq) gn
FROM board_test
START WITH parent_seq is null
CONNECT BY prior seq = parent_seq
ORDER SIBLINGS BY gn desc, seq asc; 

--�׷��ȣ�� ������ �÷��� �߰�
ALTER TABLE board_test ADD(gn NUMBER);
update board_test SET gn = 4
WHERE seq IN(4,5,6,7,8,10,11);

update board_test SET gn = 2
WHERE seq IN(2,3);

update board_test SET gn = 1
WHERE seq IN(1,9);

commit;

-- level�̳� sys�Լ� ���� order by siblings���� �ٷ� ����� �Ұ����ϴ�. ����Ϸ��� ���������� ����� �ϴµ�
-- �̷��� ���������� ���������� ������ �ȴ�.
-- ���� ���ڵ峪 ���̽������� ���� �׷��ȣ ó�� ���� order siblings by �� �׷��ȣ�� ����, seq�� ���Ľ��Ѿ��Ѵ�.
SELECT seq, lpad(' ', (LEVEL-1)*4) || title title,  DECODE(parent_seq, NULL, seq, parent_seq) gn
FROM board_test
START WITH parent_seq IS nULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn desc, seq asc;

SELECT seq, lpad(' ', (LEVEL-1)*4) || title title,
        DECODE(parent_seq, NULL, seq, parent_seq) code
FROM board_test
START WITH parent_seq IS nULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn desc, seq asc;

SELECT *
FROM BOARD_TEST;

STAR

FROM emp
ORDER BY deptno desc, empno asc;

SELECT *
FROM emp
WHERE sal = (SELECT MAX(sal)
             FROM emp);

SELECT ename, sal, deptno, ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal desc) sal_rank
FROM emp
GROUP BY ename, sal, deptno
ORDER BY deptno, sal desc;

SELECT ename, sal, deptno, rownum
FROM
(SELECT ename, sal, deptno, rownum
FROM emp
WHERE deptno =10
ORDER BY sal desc,rownum)


UNION

SELECT ename, sal, deptno, rownum
FROM
(SELECT ename, sal, deptno, rownum
FROM emp
WHERE deptno =20
ORDER BY sal desc,rownum)


UNION 

SELECT ename, sal, deptno, rownum
FROM
(SELECT ename, sal, deptno, rownum
FROM emp
WHERE deptno =30
ORDER BY sal desc,rownum)
ORDER BY  deptno, sal desc;


SELECT *
FROM
(SELECT LEVEL lv
FROM dual
CONNECT BY LEVEL <= 14) a,

(SELECT deptno, count(*) cnt
FROM emp
GROUP BY deptno) b
WHERE b.cnt >= a.lv
ORDER BY b.deptno, a.lv;

SELECT deptno, LEVEL
FROM emp
START WITH e
CONNECT BY LEVEL=1;

SELECT *
FROM
(SELECT emp.*,ROWNUM
FROM emp) a,

(SELECT deptno, count(*) cnt
FROM emp
GROUP BY deptno) b
WHERE b.cnt >= a.lv
ORDER BY b.deptno, a.lv;
