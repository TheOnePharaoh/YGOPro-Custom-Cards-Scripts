--Last Altar of the Legendary Golem
function c66165070.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xea010))
	c:RegisterEffect(e2)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66165070,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCondition(c66165070.tokcon)
	e3:SetTarget(c66165070.toktg)
	e3:SetOperation(c66165070.tokop)
	c:RegisterEffect(e3)
	--splimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(1,0)
	e4:SetCondition(c66165070.splimcon)
	e4:SetTarget(c66165070.splimit)
	c:RegisterEffect(e2)
end
function c66165070.tokcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and bit.band(eg:GetFirst():GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE
end
function c66165070.toktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c66165070.tokop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,66165071,0,0x4011,0,200,1,RACE_ROCK,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,66165071)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
function c66165070.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c66165070.splimit(e,c)
	return not c:IsRace(RACE_ROCK)
end