--Beast of Wild - Majesty Lion
function c83581508.initial_effect(c)
	c:SetUniqueOnField(1,0,83581508,LOCATION_MZONE)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA+LOCATION_GRAVE)
	e2:SetCondition(c83581508.sprcon)
	e2:SetOperation(c83581508.sprop)
	e2:SetValue(SUMMON_TYPE_SPECIAL+300)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(83581508,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c83581508.destg)
	e3:SetOperation(c83581508.desop)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(83581508,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLED)
	e4:SetCondition(c83581508.rmcon)
	e4:SetTarget(c83581508.rmtg)
	e4:SetOperation(c83581508.rmop)
	c:RegisterEffect(e4)
	--activate limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(c83581508.aclimit1)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EVENT_CHAIN_NEGATED)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(c83581508.aclimit2)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetCode(EFFECT_CANNOT_ACTIVATE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(1,0)
	e7:SetCondition(c83581508.econ1)
	e7:SetValue(c83581508.elimit)
	c:RegisterEffect(e7)
	local e8=e5:Clone()
	e8:SetOperation(c83581508.aclimit3)
	c:RegisterEffect(e8)
	local e9=e6:Clone()
	e9:SetOperation(c83581508.aclimit4)
	c:RegisterEffect(e9)
	local e10=e7:Clone()
	e10:SetCondition(c83581508.econ2)
	e10:SetTargetRange(0,1)
	c:RegisterEffect(e10)
end
function c83581508.ddfilter(c)
	return (c:GetSequence()==6 or c:GetSequence()==7) or c:IsLocation(LOCATION_MZONE)
end
function c83581508.spfilter1(c,tp)
	return c:GetLevel()==7 and c:IsFusionSetCard(0x12c) and c:IsDestructable() and c:IsCanBeFusionMaterial()
		and Duel.IsExistingMatchingCard(c83581508.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c83581508.spfilter2(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFusionSetCard(0x12c) and c83581508.ddfilter(c) and c:IsDestructable() and c:IsCanBeFusionMaterial()
end
function c83581508.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c83581508.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c83581508.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,c83581508.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectMatchingCard(tp,c83581508.spfilter2,tp,LOCATION_ONFIELD,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Destroy(g1,REASON_EFFECT)
end
function c83581508.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x12c) or c:IsSetCard(0x12e)
end
function c83581508.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c83581508.desfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c83581508.desfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c83581508.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c83581508.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	e:SetLabelObject(bc)
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsStatus(STATUS_OPPO_BATTLE)
end
function c83581508.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetLabelObject(),1,0,0)
end
function c83581508.rmop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() and bc:IsAbleToRemove() then
		Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
	end
end
function c83581508.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp or not re:IsActiveType(TYPE_MONSTER) then return end
	e:GetHandler():RegisterFlagEffect(83581508,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c83581508.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():ResetFlagEffect(83581508)
end
function c83581508.econ1(e)
	return e:GetHandler():GetFlagEffect(83581508)~=0
end
function c83581508.aclimit3(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsActiveType(TYPE_MONSTER) then return end
	e:GetHandler():RegisterFlagEffect(83581508+1,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c83581508.aclimit4(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():ResetFlagEffect(83581508+1)
end
function c83581508.econ2(e)
	return e:GetHandler():GetFlagEffect(83581508+1)~=0
end
function c83581508.elimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end