-- ============================================
-- Step 3: LIKE 検索の限界を体感する
-- ============================================

-- 3-1: LIKE 検索で「返品」を探す（ヒットする）
SELECT id, question, answer
FROM CORTEX_SEARCH_LEARN.DATA.PRODUCT_FAQ
WHERE answer LIKE '%返品%';

-- 3-2: 「商品を返したい」で LIKE 検索（ヒットしない）
SELECT id, question, answer
FROM CORTEX_SEARCH_LEARN.DATA.PRODUCT_FAQ
WHERE answer LIKE '%商品を返したい%';
