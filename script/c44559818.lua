--Xian Tian, Descendant of the Nirvana
function c44559818.initial_effect(c)
	c:SetUniqueOnField(1,0,44559818)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c44559818.spcon)
	e1:SetOperation(c44559818.spop)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c44559818.tdtg)
	e2:SetOperation(c44559818.tdop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--change battle target
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(44559818,0))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BE_BATTLE_TARGET)
	e5:SetRange(LOCATION_HAND)
	e5:SetCountLimit(1,44559818)
	e5:SetCondition(c44559818.cbcon)
	e5:SetCost(c44559818.cbcost)
	e5:SetTarget(c44559818.cbtg)
	e5:SetOperation(c44559818.cbop)
	c:RegisterEffect(e5)
end
function c44559818.spfilter(c)
	return c:IsSetCard(0x2016) or c:IsCode(44559811) and not c:IsCode(44559818)
end
function c44559818.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c44559818.spfilter,c:GetControler(),LOCATION_HAND,0,1,c)
end
function c44559818.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c44559818.spfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)
end
function c44559818.tdfilter(c)
	return c:IsFaceup() and c:GetSummonLocation()==LOCATION_EXTRA and c:IsAbleToDeck()
end
function c44559818.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c44559818.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c44559818.tdfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c44559818.tdfilter,tp,0,LOCATION_MZONE,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c44559818.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c44559818.cbcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return ec:IsFaceup() and ec:IsControler(tp) and ec:IsSetCard(0x2016) or ec:IsSetCard(0x2017) or ec:IsCode(44559811) or ec:IsCode(44559832)
end
function c44559818.cbcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c44559818.cbtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsDestructable() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function c44559818.cbop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsAttackable() and not tc:IsStatus(STATUS_ATTACK_CANCELED)
		and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,1050,REASON_EFFECT)
	end
end