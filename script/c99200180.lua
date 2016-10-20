--Dark Android Empress
function c99200180.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c99200180.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c99200180.sprcon)
	e2:SetOperation(c99200180.sprop)
	c:RegisterEffect(e2)
	--immune effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c99200180.immfilter)
	c:RegisterEffect(e3)
	--cos
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99200180,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c99200180.costg)
	e4:SetOperation(c99200180.cosop)
	c:RegisterEffect(e4)
	--recover
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(99200180,3))
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCondition(c99200180.reccon)
	e5:SetTarget(c99200180.rectg)
	e5:SetOperation(c99200180.recop)
	c:RegisterEffect(e5)
end
function c99200180.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c99200180.spfilter1(c,tp)
	return c:IsCode(99200151) and Duel.IsExistingMatchingCard(c99200180.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,3,c)
end
function c99200180.spfilter2(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c99200180.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-4
		and Duel.IsExistingMatchingCard(c99200180.spfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
end
function c99200180.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99200180,0))
	local g1=Duel.SelectMatchingCard(tp,c99200180.spfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99200180,1))
	local g2=Duel.SelectMatchingCard(tp,c99200180.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,3,3,g1:GetFirst())
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c99200180.immfilter(e,te)
	return te:IsActiveType(TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c99200180.cosfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and not c:IsCode(99200180)
end
function c99200180.costg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c99200180.cosfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99200180.cosfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c99200180.cosfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c99200180.cosop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(99200151)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c99200180.recfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xda3790) and c:IsType(TYPE_FUSION) and c:GetSummonLocation()==LOCATION_EXTRA and c:GetPreviousControler()==tp
end
function c99200180.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99200180.recfilter,1,nil,tp)
end
function c99200180.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,800)
end
function c99200180.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
