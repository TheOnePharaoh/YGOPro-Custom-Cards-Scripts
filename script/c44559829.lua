--Ne Zha, Descendant of the Nirvana
function c44559829.initial_effect(c)
	c:SetSPSummonOnce(44559829)
	c:SetUniqueOnField(1,0,44559829)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(44559829,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c44559829.spcon)
	e1:SetTarget(c44559829.sptg)
	e1:SetOperation(c44559829.spop)
	c:RegisterEffect(e1)
	--draw 1
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c44559829.target)
	e2:SetOperation(c44559829.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--draw 2
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(44559829,1))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_HAND)
	e5:SetCountLimit(1,44559829)
	e5:SetCost(c44559829.dracost)
	e5:SetTarget(c44559829.dratg)
	e5:SetOperation(c44559829.draop)
	c:RegisterEffect(e5)
end
function c44559829.spefilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2016) and not c:IsCode(99199030) and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c44559829.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c44559829.spefilter,tp,LOCATION_MZONE,0,1,nil)
end
function c44559829.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c44559829.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c44559829.spefilter,tp,LOCATION_MZONE,0,1,nil) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetReset(RESET_EVENT+0xff0000)
		e1:SetValue(1000)
		c:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetReset(RESET_EVENT+0xff0000)
		e2:SetValue(1100)
		c:RegisterEffect(e2,true)
	end
end
function c44559829.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c44559829.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c44559829.dracost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c44559829.dratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c44559829.draop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
