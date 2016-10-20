--The Legendary Meat Golem
function c66165096.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--token1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66165096,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,66165096)
	e2:SetCondition(c66165096.tokcon)
	e2:SetTarget(c66165096.toktg1)
	e2:SetOperation(c66165096.tokop1)
	c:RegisterEffect(e2)
	--token2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66165096,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,66165096)
	e3:SetCondition(c66165096.tokcon)
	e3:SetTarget(c66165096.toktg2)
	e3:SetOperation(c66165096.tokop2)
	c:RegisterEffect(e3)
	--countering
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c66165096.cbcon)
	e4:SetCost(c66165096.cbcost)
	e4:SetTarget(c66165096.cbtg)
	e4:SetOperation(c66165096.cbop)
	c:RegisterEffect(e4)
	--banish
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCondition(c66165096.remcon)
	e5:SetTarget(c66165096.remtg)
	e5:SetOperation(c66165096.remop)
	c:RegisterEffect(e5)
end
function c66165096.tokcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE
end
function c66165096.toktg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,66165097,0,0xea010,1300,0,3,RACE_ROCK,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c66165096.tokop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,66165097,0,0xea010,1300,0,3,RACE_ROCK,ATTRIBUTE_EARTH) then return end
	for i=1,2 do
		local token=Duel.CreateToken(tp,66165097)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end
function c66165096.toktg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c66165096.tokop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<2 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,66165097,0,0xea010,1300,0,3,RACE_ROCK,ATTRIBUTE_EARTH,POS_FACEUP,1-tp) then return end
	for i=1,2 do
		local token=Duel.CreateToken(tp,66165097)
		Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end
function c66165096.cbcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return ec:IsFaceup() and ec:IsControler(tp) and ec:IsAttribute(ATTRIBUTE_EARTH)
end
function c66165096.cbcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c66165096.cbtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsDestructable() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function c66165096.cbop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsAttackable() and not tc:IsStatus(STATUS_ATTACK_CANCELED)
		and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,1375,REASON_EFFECT)
	end
end
function c66165096.remcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_SUMMON and c:GetReasonCard():IsSetCard(0xea010)
end
function c66165096.remfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c66165096.remtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c66165096.remfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66165096.remfilter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c66165096.remfilter,tp,0,LOCATION_GRAVE,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c66165096.remop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
