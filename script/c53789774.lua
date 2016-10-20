--Tsuji, The Earth Guarding Taoist Dragon
function c53789774.initial_effect(c)
	--fus limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetValue(c53789774.interactlimit)
	c:RegisterEffect(e1)
	--sync limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetValue(c53789774.interactlimit)
	c:RegisterEffect(e2)
	--xyz limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetValue(c53789774.interactlimit)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(53789774,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1,53789774)
	e4:SetCondition(c53789774.condition)
	e4:SetTarget(c53789774.target)
	e4:SetOperation(c53789774.operation)
	c:RegisterEffect(e4)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(53789774,1))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c53789774.drcon)
	e5:SetTarget(c53789774.drtarg)
	e5:SetOperation(c53789774.drop)
	c:RegisterEffect(e5)
end
function c53789774.interactlimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_WYRM)
end
function c53789774.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x0cab90)
end
function c53789774.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c53789774.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c53789774.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,200,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c53789774.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c53789774.cfilter,tp,LOCATION_MZONE,0,1,nil) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,200,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_HAND)
		c:RegisterEffect(e1,true)
	end
end
function c53789774.drcon(e,tp,eg,ep,ev,re,r,rp)
	local st=e:GetHandler():GetSummonType()
	return st>=(SUMMON_TYPE_SPECIAL+200) and st<(SUMMON_TYPE_SPECIAL+250)
end
function c53789774.drtarg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c53789774.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end