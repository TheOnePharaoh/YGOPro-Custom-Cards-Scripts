--Matter Inversion
function c103950032.initial_effect(c)
	
	--Switch ATK and DEF
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950032,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c103950032.target)
	e1:SetOperation(c103950032.activate)
	c:RegisterEffect(e1)
end

--Switch ATK and DEF target
function c103950032.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end

--Switch ATK and DEF operation
function c103950032.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Card.IsFaceup(tc) then
		if tc:GetFlagEffect(103950032) == 0 then
			tc:RegisterFlagEffect(103950032,RESET_EVENT+0x1fe0000,0,1)
			
			local atk=tc:GetAttack()
			local def=tc:GetDefense()
			
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(def)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetValue(atk)
			tc:RegisterEffect(e2)
			
			if not tc:IsImmuneToEffect(e) then
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
				e3:SetReset(RESET_EVENT+0x47e0000)
				e3:SetValue(LOCATION_REMOVED)
				tc:RegisterEffect(e3,true)
			end
		else
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end