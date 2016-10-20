--Toon Hagane Miku
function c57888882.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c57888882.splimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c57888882.spcon)
	e2:SetOperation(c57888882.spop)
	c:RegisterEffect(e2)
	--cannot attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetOperation(c57888882.atklimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--direct attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_DIRECT_ATTACK)
	e6:SetCondition(c57888882.dircon)
	c:RegisterEffect(e6)
	--destroy
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(57888882,0))
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_BATTLE_START)
	e7:SetTarget(c57888882.destg)
	e7:SetOperation(c57888882.desop)
	c:RegisterEffect(e7)
	--immune monster
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_IMMUNE_EFFECT)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetValue(c57888882.immfilter)
	c:RegisterEffect(e8)
	--copy
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(57888882,1))
	e9:SetCategory(CATEGORY_ATKCHANGE)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1)
	e9:SetTarget(c57888882.copytg)
	e9:SetOperation(c57888882.copyop)
	c:RegisterEffect(e9)
end
function c57888882.confilter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c57888882.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if not Duel.IsExistingMatchingCard(c57888882.confilter,tp,LOCATION_ONFIELD,0,1,nil) then return false end
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),Card.IsType,1,nil,TYPE_TOON)
end
function c57888882.splimit(e,se,sp,st,spos,tgp)
	return Duel.IsExistingMatchingCard(c57888882.cfilter,tgp,LOCATION_ONFIELD,0,1,nil)
end
function c57888882.cfilter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c57888882.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),Card.IsType,1,1,nil,TYPE_TOON)
	Duel.Release(g,REASON_COST)
end
function c57888882.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c57888882.cfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c57888882.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c57888882.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c57888882.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(c57888882.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end
function c57888882.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc and tc:IsFaceup() and not tc:IsType(TYPE_TOON) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c57888882.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc:IsRelateToBattle() then Duel.Destroy(tc,REASON_EFFECT) end
end
function c57888882.immfilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c57888882.copyfilter(c)
	return c:IsType(TYPE_TOON)
		and not c:IsHasEffect(EFFECT_FORBIDDEN) and c:IsAbleToRemove() and not c:IsCode(57888882)
end
function c57888882.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c57888882.copyfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c57888882.copyfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c57888882.copyfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c57888882.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=1 then	return end
		local code=tc:GetOriginalCode()
		local cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(200)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(57888882,2))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetLabel(cid)
		e2:SetOperation(c57888882.rstop)
		c:RegisterEffect(e2)
	end
end
function c57888882.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	c:ResetEffect(cid,RESET_COPY)
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
