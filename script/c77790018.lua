--Dark Tuner:Arias Eye
function c77790018.initial_effect(c)
	--synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c77790018.synlimit)
	c:RegisterEffect(e1)
	--lvchange
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77790018,1))
	e2:SetCategory(CATEGORY_LVCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c77790018.lvcon)
	e2:SetOperation(c77790018.lvop)
	c:RegisterEffect(e2)
end
function c77790018.synlimit(e,c)
	if not c then return false end
	local code=c:GetOriginalCode()
	if code==100000150 or code==100000151 or code==100000152 or code==100000153 or code==100000154 or code==100000155 or code==100000156 then
	return else return not c:IsSetCard(0x301) end
end
function c77790018.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsDefensePos()
end
function c77790018.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=Duel.AnnounceNumber(tp,1,2,3,4,5,6,7,8,9,10,11,12,13,14)
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
