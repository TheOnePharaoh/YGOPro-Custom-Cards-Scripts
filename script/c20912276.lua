--Byakko
function c20912276.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c20912276.spcon)
	c:RegisterEffect(e1)
	--lv change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20912276,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c20912276.lvcon)
	e2:SetTarget(c20912276.lvtg)
	e2:SetOperation(c20912276.lvop)
	c:RegisterEffect(e2)
	--xyzlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c20912276.xyzlimit)
	c:RegisterEffect(e3)
end
function c20912276.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd0a2) and not c:IsType(TYPE_XYZ) and not c:IsCode(20912276)
end
function c20912276.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and	Duel.IsExistingMatchingCard(c20912276.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c20912276.lvcon(e)
	return e:GetHandler():GetEquipCount()>0
end
function c20912276.filter(c,clv)
	local lv=c:GetLevel()
	return c:IsSetCard(0xd0a2) and not c:IsType(TYPE_XYZ) and lv~=0 and lv~=clv
		and ((c:IsLocation(LOCATION_MZONE) and c:IsFaceup()) or c:IsLocation(LOCATION_GRAVE))
end
function c20912276.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c20912276.filter(chkc,e:GetHandler():GetLevel()) end
	if chk==0 then return Duel.IsExistingTarget(c20912276.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,e:GetHandler(),e:GetHandler():GetLevel()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c20912276.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,e:GetHandler(),e:GetHandler():GetLevel())
end
function c20912276.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e)
		and (not tc:IsLocation(LOCATION_MZONE) or tc:IsFaceup()) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(tc:GetLevel())
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e:GetHandler():RegisterEffect(e1)
	end
end
function c20912276.xyzlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0xd0a2)
end
