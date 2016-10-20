--The Fourth Panticle of Wrath
function c80106550.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCondition(c80106550.descon)
	e1:SetTarget(c80106550.destg)
	e1:SetOperation(c80106550.desop)
	c:RegisterEffect(e1)
	--self destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c80106550.sdcon)
	c:RegisterEffect(e2)
	--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_PIERCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c80106550.desrepcon)
	e3:SetTarget(c80106550.pietg)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80106550,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCondition(c80106550.spcon)
	e4:SetCost(c80106550.spcost)
	e4:SetTarget(c80106550.sptg)
	e4:SetOperation(c80106550.spop)
	c:RegisterEffect(e4)
end
function c80106550.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:IsFaceup() and tc:IsSetCard(0xca00)
end
function c80106550.desfilter(c)
	return c:IsAttackPos() and c:IsDestructable()
end
function c80106550.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80106550.desfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c80106550.desfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c80106550.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c80106550.desfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c80106550.sdfilter(c)
	return not c:IsFaceup() or not c:IsSetCard(0xca00)
end
function c80106550.sdcon(e)
	return Duel.IsExistingMatchingCard(c80106550.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c80106550.cfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c80106550.desrepcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
		and not Duel.IsExistingMatchingCard(c80106550.cfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c80106550.cfilter,tp,0,LOCATION_GRAVE,1,nil)
end
function c80106550.pietg(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xca00)
end
function c80106550.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():IsPreviousLocation(LOCATION_HAND) and not e:GetHandler():IsReason(REASON_RETURN)
end
function c80106550.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c80106550.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,80106550,0,0xca00,8,2900,1000,RACE_WARRIOR,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c80106550.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,80106550,0,0xca00,8,2900,1000,RACE_WARRIOR,ATTRIBUTE_DARK) then
		c:SetStatus(STATUS_NO_LEVEL,false)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_EFFECT+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		c:RegisterEffect(e1,true)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e7:SetReset(RESET_EVENT+0x47e0000)
		e7:SetValue(LOCATION_DECKBOT)
		c:RegisterEffect(e7,true)
	end
end