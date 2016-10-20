--Primordial Crystal
--lua script by SGJin
function c12310714.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c12310714.condition)
	e1:SetTarget(c12310714.target)
	e1:SetOperation(c12310714.activate)
	c:RegisterEffect(e1)
end
function c12310714.filter(c,p)
	return c:GetControler()==p and c:IsOnField()
end
function c12310714.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainDisablable(ev) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(c12310714.filter,nil,tp)-tg:GetCount()>1
end
function c12310714.sfilter(c,e,tp)
	return c:IsCode(12310706) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12310714.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c12310714.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.NegateEffect(ev)
	if re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
		local sc=Duel.GetFirstMatchingCard(c12310714.sfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		if sc and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.SelectYesNo(tp,aux.Stringid(12310714,0)) then
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,12310714,0,0x21,0,1000,1,RACE_ROCK,ATTRIBUTE_LIGHT) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
	c:AddMonsterAttributeComplete()
	--Seath is Immortal as long as crystal is active
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(c12310714.etarget)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c12310714.etarget)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c12310714.etarget)
	e3:SetValue(1)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e3)
end
function c12310714.etarget(e,c)
	return c:IsCode(12310706)
end
