--�õ�, �ñ���, ��������
--���� ���� �ܹ��� ����
SELECT up.sido,up.sigungu,ROUND(bmk/b,2) c , dense_rank() over(order by ROUND(bmk/b,2) desc) rank
FROM(
     
     
        (SELECT sido, sigungu,count(gb) bmk
         FROM fastfood
         WHERE gb IN ('����ŷ','�Ƶ�����','KFC')
         GROUP BY sido, sigungu) up

    JOIN
    
    (SELECT sido, sigungu,gb,count(gb) b
     FROM fastfood
     WHERE gb IN ('�Ե�����')
     GROUP BY sido, sigungu,gb )down
     
    ON(up.sido=down.sido and up.sigungu = down.sigungu))
ORDER BY c DESC;


--�������� ����� �ڵ�
--fastfood ���̺��� �ѹ��� �д� ������� �ۼ��ϱ�
--�Ʒ��� ���� �ڵ带 �ۼ��Ҷ� �и� �Ǵ� �Ե����ư� 0 �ϰ�찡 ����� �̶��� ������ ó���ϴ°� �ƴ϶�
--����ڿ��� ����� �ϴ°��� ����.


SELECT sido, sigungu, ROUND((kfc+����ŷ+mac)/�Ե�����,2) score
FROM
        (SELECT sido, sigungu,
            NVL(SUM(DECODE(gb, 'KFC', 1)),0) kfc, NVL(SUM(DECODE(gb, '����ŷ', 1)),0)����ŷ,
            NVL(SUM(DECODE(gb, '�Ƶ�����', 1)),0) mac, NVL(SUM(DECODE(gb, '�Ե�����', 1)),1)�Ե�����
        FROM fastfood
        WHERE gb IN('KFC','����ŷ','�Ƶ�����','�Ե�����')
        GROUP BY sido, sigungu)
ORDER BY score desc;

