--Mass Breeding Nest
function c78330028.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(78330028,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c78330028.tokcon)
	e2:SetTarget(c78330028.toktg)
	e2:SetOperation(c78330028.tokop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(78330028,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c78330028.damcost)
	e3:SetTarget(c78330028.target)
	e3:SetOperation(c78330028.operation)
	c:RegisterEffect(e3)
end
function c78330028.drafilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xac9812)
end
function c78330028.tokcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetFirst():GetSummonType()==SUMMON_TYPE_XYZ and eg:GetFirst():IsControler(tp) and eg:IsExists(c78330030.drafilter,1,nil)
end
function c78330028.toktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c78330028.tokop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,78330031,0,0x4011,100,100,4,RACE_INSECT,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,78330031)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c78330028.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsCode,2,nil,78330031) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsCode,2,2,nil,78330031)
	Duel.Release(g,REASON_COST)
end
function c78330028.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c78330028.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
