--Humanity Phantom
--lua script by SGJin
function c12310730.initial_effect(c)
	--Drain Life when summoned / flipped face up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12310730,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c12310730.target)
	e1:SetOperation(c12310730.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP)
	c:RegisterEffect(e2)
	-- Treated as Humanity While in grave (Hand and Banish don't seem to work) 
	--not work still
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetCondition(c12310730.con)
	e3:SetValue(12310712)
	c:RegisterEffect(e3)
end
function c12310730.filter(c)
	return c:IsFaceup() and c:GetLevel()>0 and c:GetCode()~=12310730
end
function c12310730.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c12310730.filter(chkc) end
	if chk==0 then return true end
	Duel.SelectTarget(tp,c12310730.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c12310730.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(-1)
		tc:RegisterEffect(e1)
		local lp=Duel.GetLP(tc:GetControler())-tc:GetLevel()*200
		Duel.SetLP(tc:GetControler(),lp)
	end
end
function c12310730.con(e)
	return e:GetHandler():IsLocation(LOCATION_HAND+LOCATION_REMOVED)
end
