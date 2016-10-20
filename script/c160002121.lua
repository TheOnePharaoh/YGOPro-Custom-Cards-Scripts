--Galting Yukiron Dragon
function c160002121.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,81480460,160005658,true,true)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(160002121,0))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_COIN)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c160002121.destg)
	e3:SetOperation(c160002121.desop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e4:SetValue(c160002121.limit)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(c160002121.efilter)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e6:SetValue(c160002121.limit)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e7:SetValue(c160002121.tgvalue)
	c:RegisterEffect(e7)
	--
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_SCRAP_CHIMERA)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetValue(c160002121.synlimit2)
	c:RegisterEffect(e9)
end
function c160002121.limit(e,c)
	if not c then return false end
	return c:GetControler()~=e:GetHandler():GetOwner()
end
function c160002121.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_TRAP) and c:IsDestructable()
end
function c160002121.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(1-tp) and c160002121.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c160002121.filter,tp,0,LOCATION_SZONE,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c160002121.filter,tp,0,LOCATION_SZONE,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,3)
end
function c160002121.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg then
		local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
		local c1,c2,c3=Duel.TossCoin(tp,3)
		if c1+c2+c3<2 then return end
		Duel.Destroy(sg,nil,REASON_EFFECT)
	end
end
function c160002121.tgvalue(e,c)
	if not c then return false end
	return not c:IsSetCard(0x89b)
end
function c160002121.synlimit2(e,c)
	return c:GetControler()~=e:GetHandler():GetOwner()
end
function c160002121.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end