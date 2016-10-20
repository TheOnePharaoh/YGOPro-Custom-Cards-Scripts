--Bian Cheng Wang, Jade Empress of the Sky Nirvana
function c44559826.initial_effect(c)
	c:SetUniqueOnField(1,0,44559826)
	--fusion material
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x2016),aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),true)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--Immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(c44559826.tgvalue)
	c:RegisterEffect(e3)
	--pos
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCondition(c44559826.poscon)
	e4:SetTarget(c44559826.postg)
	e4:SetOperation(c44559826.posop)
	c:RegisterEffect(e4)
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(44559826,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c44559826.negcost)
	e5:SetOperation(c44559826.negop)
	c:RegisterEffect(e5)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(44559826,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCondition(c44559826.spcon)
	e6:SetCost(c44559826.spcost)
	e6:SetTarget(c44559826.sptg)
	e6:SetOperation(c44559826.spop)
	c:RegisterEffect(e6)
end
function c44559826.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c44559826.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end
function c44559826.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(aux.TRUE,1-tp,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetFieldGroup(1-tp,aux.TRUE,tp,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,sg,sg:GetCount(),0,0)
end
function c44559826.posop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetFieldGroup(1-tp,LOCATION_MZONE,nil)
	if sg:GetCount()>0 then
		Duel.ChangePosition(sg,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		local tc=sg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			tc=sg:GetNext()
		end
	end
end
function c44559826.costfilter(c)
	return c:IsSetCard(0x2016) or c:IsSetCard(0x2017) or c:IsCode(44559811) or c:IsCode(44559832) and c:IsAbleToDeckAsCost()
end
function c44559826.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44559826.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c44559826.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c44559826.begfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c44559826.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c44559826.begfilter,tp,0,LOCATION_MZONE,c)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(c44559826.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c44559826.aclimit(e,re,tp)
	return re:GetHandler():IsOnField() and not re:GetHandler():IsImmuneToEffect(e)
end
function c44559826.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetPreviousLocation(),LOCATION_ONFIELD)>0
end
function c44559826.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c44559826.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2016) and c:CheckUniqueOnField(tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c44559826.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c44559826.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c44559826.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c44559826.spfilter,tp,LOCATION_GRAVE,0,ft,ft,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		c:SetCardTarget(tc)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end