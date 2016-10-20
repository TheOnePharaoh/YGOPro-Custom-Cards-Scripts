--Line-up Formation
function c22769917.initial_effect(c)
	c:SetUniqueOnField(1,0,22769917)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetCondition(c22769917.spcon)
	e2:SetTarget(c22769917.sptg)
	e2:SetOperation(c22769917.spop)
	c:RegisterEffect(e2)
	--Counter Trap activate in set turn
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_SZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_COUNTER))
	c:RegisterEffect(e3)
	--cannot spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(c22769917.sumlimit)
	c:RegisterEffect(e4)
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22769917,0))
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c22769917.damcon)
	e5:SetCost(c22769917.damcost)
	e5:SetTarget(c22769917.damtg)
	e5:SetOperation(c22769917.damop)
	c:RegisterEffect(e5)
end
function c22769917.spcon(e,tp,eg,ep,ev,re,r,rp)
	local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
	return de and dp~=tp and re:GetHandler():IsType(TYPE_COUNTER) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp
end
function c22769917.filter(c,e,tp)
	return c:IsSetCard(0xaa12) and c:IsLevelAbove(10)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c22769917.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22769917.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c22769917.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22769917.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
function c22769917.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsRace(RACE_MACHINE)
end
function c22769917.conditfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c22769917.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22769917.conditfilter,tp,LOCATION_MZONE,0,2,nil)
end
function c22769917.costfilter(c)
	return c:IsType(TYPE_COUNTER) and c:IsAbleToGraveAsCost()
end
function c22769917.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22769917.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22769917.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c22769917.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c22769917.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
