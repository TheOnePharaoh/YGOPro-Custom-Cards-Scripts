--Twin Humanity
--lua script by SGJin
function c12310713.initial_effect(c)
	--Lvl +2
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetCountLimit(1,12310713+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c12310713.target)
	e1:SetOperation(c12310713.operation)
	c:RegisterEffect(e1)
	--Treated as Humanity while in Grave, Hand and Banish don't seem to work. :/ 
	--I will make this work xD
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetValue(12310712)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(12310713)
	e3:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e3)
end
function c12310713.filter(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function c12310713.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c12310713.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12310713.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local tc=Duel.SelectTarget(tp,c12310713.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tc:GetControler(),tc:GetLevel()*200+400)
end
function c12310713.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(2)
		tc:RegisterEffect(e1)
		Duel.Recover(tc:GetControler(),tc:GetLevel()*200,REASON_EFFECT)
	end
end

