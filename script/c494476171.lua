--ＮＯ１３ エーテリック・アメン
function c494476171.initial_effect(c)
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c494476171.splimit)
	c:RegisterEffect(e1)
	--indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)	
	--attack up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(c494476171.atkval)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetTarget(c494476171.destg)
	e5:SetOperation(c494476171.desop)
	c:RegisterEffect(e5)
	--draw
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c494476171.con)
	e6:SetTarget(c494476171.tg)
	e6:SetOperation(c494476171.op)
	c:RegisterEffect(e6)
end
function c494476171.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x95)
end
function c494476171.atkval(e,c)
	return e:GetHandler():GetOverlayCount()*100
end
function c494476171.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c494476171.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c494476171.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c494476171.filter,tp,0,LOCATION_ONFIELD,1,nil)
	 and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c494476171.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c494476171.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local dr=e:GetHandler():GetRank()-tc:GetRank()
		if Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)<=dr then
			dr=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
		end
		Duel.Overlay(e:GetHandler(),Duel.GetDecktopGroup(1-tp,dr))
	end
end
function c494476171.gfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsControler(tp)
end
function c494476171.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c494476171.gfilter,1,nil,1-tp)
end
function c494476171.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c494476171.gfilter,1,nil,1-tp) end
	Duel.SetTargetCard(eg)
end
function c494476171.filter2(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsControler(tp) and c:IsRelateToEffect(e)
end
function c494476171.op(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c494476171.filter2,nil,e,1-tp)
	local tc=g:GetFirst()
	if not tc then return end
	local dr=e:GetHandler():GetRank()-tc:GetRank()
	if Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)<=dr then
		dr=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
	end
	Duel.Overlay(e:GetHandler(),Duel.GetDecktopGroup(1-tp,dr))
end
