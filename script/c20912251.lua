--silica
function c20912251.initial_effect(c)
	--effects
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetDescription(aux.Stringid(20912251,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,20912251)
	e1:SetCondition(c20912251.effcon)
	e1:SetTarget(c20912251.efftg)
	e1:SetOperation(c20912251.effop)
	c:RegisterEffect(e1)
	--synchro limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c20912251.synlimit)
	c:RegisterEffect(e2)
end
function c20912251.effcon(e)
	return e:GetHandler():GetEquipCount()>0
end
function c20912251.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_EQUIP) and c:IsDiscardable()
end
function c20912251.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20912251.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c20912251.cfilter,1,1,REASON_COST+REASON_DISCARD)
	local opt=0
	if e:GetHandler():GetLevel()==4 then
		opt=Duel.SelectOption(tp,aux.Stringid(20912251,1))
	else
		opt=Duel.SelectOption(tp,aux.Stringid(20912251,1),aux.Stringid(20912251,2))
	end
	e:SetLabel(opt)
	if opt==0 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
	end
end
function c20912251.effop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		Duel.Damage(1-tp,500,REASON_EFFECT)
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(4)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e1)
	end
end
function c20912251.synlimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_WARRIOR)
end
