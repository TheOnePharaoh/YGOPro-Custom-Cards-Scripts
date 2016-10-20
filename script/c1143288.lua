--Zero Point Black Hole, ANTI-MATTER Last Defense
function c1143288.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c1143288.reptg)
	e2:SetValue(c1143288.repval)
	c:RegisterEffect(e2)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e2:SetLabelObject(g)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1143288,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c1143288.rmcost)
	e3:SetTarget(c1143288.rmtg)
	e3:SetOperation(c1143288.rmop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1143288,2))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetTarget(c1143288.destg)
	e4:SetOperation(c1143288.desop)
	c:RegisterEffect(e4)
	if not c1143288.global_check then
		c1143288.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_SZONE+LOCATION_OVERLAY,LOCATION_DECK+LOCATION_HAND+LOCATION_SZONE+LOCATION_OVERLAY)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,1143288))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function c1143288.aafil(c)
	return c:IsSetCard(0xaf75)
end
function c1143288.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c1143288.aafil(c) and c:IsReason(REASON_BATTLE) and c:GetFlagEffect(1143288)==0
end
function c1143288.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c1143288.repfilter,1,nil,tp) end
	local g=eg:Filter(c1143288.repfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(1143288,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(1143288,0))
		tc=g:GetNext()
	end
	e:GetLabelObject():Clear()
	e:GetLabelObject():Merge(g)
	return true
end
function c1143288.repval(e,c)
	return e:GetLabelObject():IsContains(c)
end
function c1143288.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xaf75) and c:IsDestructable()
end
function c1143288.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1143288.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c1143288.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Destroy(g,REASON_COST)
end
function c1143288.tgfilter(c)
	return c:IsAbleToRemove()
end
function c1143288.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1143288.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1143288.tgfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c1143288.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c1143288.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c1143288.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end
function c1143288.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT,LOCATION_REMOVED)
end
