--Beelzebub, Arch King of the Black Art
function c77628941.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c77628941.ffilter,4,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77628941,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c77628941.remtg)
	e2:SetOperation(c77628941.remop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,77628941)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c77628941.descon)
	e3:SetCost(c77628941.descost)
	e3:SetTarget(c77628941.destg)
	e3:SetOperation(c77628941.desop)
	c:RegisterEffect(e3)
	--effect indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetCountLimit(1)
	e4:SetValue(c77628941.valcon)
	c:RegisterEffect(e4)
end
function c77628941.ffilter(c)
	return c:IsSetCard(0xba003) and c:IsType(TYPE_FUSION)
end
function c77628941.remfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_ZOMBIE) and c:IsAbleToRemove()
end
function c77628941.remtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c77628941.remfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c77628941.remfilter,tp,0,LOCATION_GRAVE,1,120,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c77628941.remop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local c=e:GetHandler()
	if ct>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetValue(ct*100)
		c:RegisterEffect(e1)
	end
end
function c77628941.grafilter(c)
	return c:IsSetCard(0xba003) and c:IsType(TYPE_MONSTER)
end
function c77628941.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c77628941.grafilter,tp,LOCATION_GRAVE,0,7,nil)
end
function c77628941.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsDirectAttacked() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c77628941.desfilter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c77628941.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c77628941.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77628941.desfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c77628941.desfilter,tp,0,LOCATION_MZONE,1,1,nil)
	local atk=g:GetFirst():GetTextAttack()
	if atk<0 then atk=0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function c77628941.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		end
	end
end
function c77628941.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end