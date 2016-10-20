--The Future Gear Great Lancer
function c99199007.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c99199007.splimit)
	e2:SetCondition(c99199007.splimcon)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,99199007)
	e3:SetTarget(c99199007.destg)
	e3:SetOperation(c99199007.desop)
	c:RegisterEffect(e3)
	--lv
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99199007,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetTarget(c99199007.target)
	e4:SetOperation(c99199007.operation)
	c:RegisterEffect(e4)
end
function c99199007.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xff15) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c99199007.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c99199007.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and tc and tc:IsSetCard(0xff15) and not tc:IsCode(99199007) and e:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c99199007.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c99199007.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:GetLevel()>0 and not c:IsType(TYPE_XYZ)
end
function c99199007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99199007.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99199007.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c99199007.filter,tp,LOCATION_MZONE,0,1,2,nil)
end
function c99199007.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
