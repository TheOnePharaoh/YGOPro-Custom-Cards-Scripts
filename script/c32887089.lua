--Guardian of the Divine Light
function c32887089.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32887089,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,32887089)
	e1:SetCondition(c32887089.condition)
	e1:SetTarget(c32887089.target)
	e1:SetOperation(c32887089.operation)
	c:RegisterEffect(e1)
	--tuner related
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32887089,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(c32887089.sccon)
	e2:SetTarget(c32887089.sctg)
	e2:SetOperation(c32887089.scop)
	c:RegisterEffect(e2)
end
function c32887089.condition(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)>Duel.GetLP(1-tp)
end
function c32887089.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,200,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c32887089.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),200,tp,tp,false,false,POS_FACEUP)
	end
end
function c32887089.sccon(e,tp,eg,ep,ev,re,r,rp)
	local st=e:GetHandler():GetSummonType()
	return st>=(SUMMON_TYPE_SPECIAL+200) and st<(SUMMON_TYPE_SPECIAL+250)
end
function c32887089.tunfilter(c)
	return c:IsFaceup() and c:IsLevelBelow(4) and c:IsSetCard(0x1e20) and not c:IsType(TYPE_TUNER)
end
function c32887089.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c32887089.tunfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c32887089.tunfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c32887089.tunfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c32887089.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c32887089.tunfilter(tc) and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end