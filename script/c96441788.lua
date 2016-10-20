--Nekomimi Switch - Song of Invitation
function c96441788.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetDescription(aux.Stringid(96441788,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetCountLimit(1)
	e2:SetCondition(c96441788.condition)
	e2:SetTarget(c96441788.target)
	e2:SetOperation(c96441788.operation)
	c:RegisterEffect(e2)
end
function c96441788.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE) and c:IsLocation(LOCATION_GRAVE) and c:GetPreviousControler()==tp and c:IsType(TYPE_TUNER) and c:IsSetCard(0x0dac405)
end
function c96441788.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c96441788.cfilter,1,nil,tp)
end
function c96441788.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c96441788.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,96441789,0,0x4011,100,100,3,RACE_MACHINE,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,96441789)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
